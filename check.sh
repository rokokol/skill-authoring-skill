#!/usr/bin/env bash
# The gate for this repository: lint what the skill ships, hold it to its own rules, and
# prove that each of its checks can actually go red. A check that has never failed is a
# decoration, and this skill hands its checker to every other skill repository.
#
# Nothing here touches the network, so it is safe on pull requests.
#
#   check.sh [lint|behaviour|all]
#
# Two halves, because they need different things. `lint` reads what the skill ships — the
# scripts, the workflows, the docs and the vendored copies — with the linters the flake's
# dev shell pins: actionlint, shellcheck, shfmt. `behaviour` runs check-skill.sh on this
# repository and probes what its self-falsification cannot, and needs only bash and POSIX
# tools, so it runs under the bash 3.2 macOS ships, which is what check-skill.sh claims to
# run on. `all`, the default, is both.
#
#   nix develop -c ./check.sh
#   /bin/bash ./check.sh behaviour        # on a macOS runner, CHECK_BASH32=1
set -euo pipefail

HERE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$HERE"

# One source of truth for what gets linted. A second copy of this list drifts, and a
# drifted list lies about what was checked.
scripts=(check.sh check-skill.sh check-sh.sh check-pins.sh vendor-sync.sh)
skill_name=skill-authoring

fail() {
  printf 'check: %s\n' "$1" >&2
  exit 1
}

# Every script below runs under the bash running this gate, not under whatever bash its
# shebang finds: on a macOS runner the gate is started as /bin/bash to prove the 3.2 macOS
# ships, while `env bash` would find Homebrew's 5
skill() { "$BASH" "$HERE/check-skill.sh" "$@"; }
checker() { "$BASH" "$HERE/check-sh.sh" "$@"; }

# With a template, so a crashed run's leftovers say whose they are
work=$(mktemp -d "${TMPDIR:-/tmp}/check.XXXXXX")
trap 'rm -rf "$work"' EXIT

mode="${1:-all}"
case "$mode" in
  lint | behaviour | all) ;;
  *)
    printf 'check: no such mode: %s — lint, behaviour or all\n' "$mode" >&2
    exit 2
    ;;
esac

tools=()
[[ "$mode" == behaviour ]] || tools+=(actionlint shellcheck shfmt)
missing=()
for tool in "${tools[@]+"${tools[@]}"}"; do
  command -v "$tool" >/dev/null || missing+=("$tool")
done
((${#missing[@]} == 0)) ||
  fail "missing: ${missing[*]} — they are pinned in the flake, so run this as: nix develop -c ./check.sh"

check_lint() {
  echo "== the scripts parse and lint"
  for s in "${scripts[@]}"; do bash -n "$s"; done
  shellcheck "${scripts[@]}"
  shfmt -d -i 2 -ci "${scripts[@]}"

  echo "== the workflows are valid, and their tools come from the lock rather than a registry"
  [[ -d .github/workflows ]] || fail ".github/workflows is missing — nothing gates this repository"
  actionlint
  # The lint must be able to bite: a step with neither uses nor run is rejected
  mkdir -p "$work/bad/.github/workflows"
  cp tests/fixtures/must-fail.yml "$work/bad/.github/workflows/"
  if (cd "$work/bad" && actionlint .github/workflows/*.yml >/dev/null 2>&1); then
    fail "actionlint passed tests/fixtures/must-fail.yml — it cannot catch anything"
  fi
  # The pin guard, vendor-sync.sh, check-pins.sh and the two workflows are vendored from
  # the ci skill (https://github.com/rokokol/ci-skill) and check-sh.sh from the
  # bash-best-practices skill (https://github.com/rokokol/bash-best-practices-skill):
  # every copy must still be the blob .github/vendor.lock records, so one edited here
  # instead of at its source fails by name
  ./vendor-sync.sh check
  # The pin guard proves on every run that it catches each unpinned shape and stays quiet on
  # the pinned spellings, then scans the workflows
  ./check-pins.sh

  echo "== no paragraph in the docs is hard-wrapped or ends on a full stop"
  # GitHub soft-wraps, so a manual break means a one-word edit reflows every line after it,
  # and a paragraph ends bare. The rules' home is the create-readme skill
  # (https://github.com/rokokol/create-readme-skill), which cannot be assumed present in
  # CI, so their machine-decidable part is spelled here — over every doc the skill ships,
  # not the readme alone: SKILL.md and the references are what an agent reads
  local docs=(README.md SKILL.md CHANGELOG.md DEVIATIONS.md PITFALLS.md references/*.md) doc wrapped stopped
  for doc in "${docs[@]}"; do
    wrapped=$(hard_wrapped "$doc")
    [[ -z "$wrapped" ]] ||
      fail "$doc hard-wraps a paragraph at line(s): $(tr '\n' ' ' <<<"$wrapped")— one paragraph is one line"
    stopped=$(full_stopped "$doc")
    [[ -z "$stopped" ]] ||
      fail "$doc ends prose on a full stop at line(s): $(tr '\n' ' ' <<<"$stopped")— the last sentence ends bare"
  done
  # Both able to fail, on the shapes they claim: a wrapped paragraph and a wrapped list item,
  # a full stop bare and one behind closing markup
  printf 'one line of a paragraph\nand the next line of it\n\n- a list item\n  wrapped onto a second line\n' >"$work/wrapped.md"
  [[ "$(hard_wrapped "$work/wrapped.md" | wc -l)" -eq 2 ]] ||
    fail "the hard-wrap check missed a wrapped paragraph or a wrapped list item"
  printf 'A sentence.\n\n**A bold one.**\n\n(A parenthesis.)\n' >"$work/stopped.md"
  [[ "$(full_stopped "$work/stopped.md" | wc -l)" -eq 3 ]] ||
    fail "the full-stop check missed a full stop, bare or behind markup"
}

hard_wrapped() { # hard_wrapped FILE -> the offending line numbers
  awk '
    # the frontmatter is YAML, whose keys sit one per line
    NR == 1 && /^---$/ { front = 1; next }
    front { if (/^---$/) front = 0; next }
    /^```/ { fence = !fence; prev = 0; item = 0; next }
    fence { next }
    # a list item continued on an indented line is a wrapped list item
    item && /^  +[^ ]/ && !/^  +([-*+]|[0-9]+\.) / { print NR; next }
    /^[-*+] / || /^[0-9]+\. / { prev = 0; item = 1; next }
    /^[[:space:]]*$/ || /^[#|>< ]/ || /^!\[/ || /^\[/ { prev = 0; item = 0; next }
    { if (prev) print NR; prev = 1; item = 0 }
  ' "$1"
}

full_stopped() { # full_stopped FILE -> the lines of prose that end on a full stop
  awk '
    NR == 1 && /^---$/ { front = 1; next }
    front { if (/^---$/) front = 0; next }
    /^```/ { fence = !fence; next }
    fence || /^    / || /^[|]/ { next }
    # seen through the markup that can close after it: `.**` and `.)` end on a stop too
    { s = $0; sub(/[*_)`"]+$/, "", s); if (s ~ /[^.]\.$/) print NR }
  ' "$1"
}

check_behaviour() {
  echo "== the checker keeps its promises: its help, its flags, its codes, its bash 3.2 claim"
  # The bash-best-practices skill's checker, vendored: it reads check-skill.sh's flag parser
  # and exit codes out of the source and holds the help to them, and greps the script for
  # constructs newer than the bash 3.2 its header claims — a proxy, with the proof being
  # this half under 3.2. It plants its own defects on every run, so nothing here has to
  # prove it can fail
  checker check-skill.sh

  echo "== this repository is the first skill the checker has to be right about"
  # SKILL.md loads, every reference is reached, every link and anchor resolves, and each
  # check — error or warning — is proven able to fire on a planted copy, by the script
  # itself, on every run. The skill that teaches the rules keeps them: under --strict a
  # warning is a finding, so this repository is held to its own warnings as errors
  skill --strict -n "$skill_name" .

  echo "== the probes the checker's own falsification cannot make"
  local out status c
  # A usage error is 2 with the script's own message, not 1 with bash's: `${2:?}` would
  # exit 1, which a gate reads as a finding
  status=0
  out=$(skill -n 2>&1) || status=$?
  ((status == 2)) || fail "check-skill.sh -n with no name exited $status, where its help promises 2 for a usage error"
  grep -q '^check-skill: -n needs a name' <<<"$out" || fail "check-skill.sh -n with no name did not say what is missing: $out"
  # The help names every warning id the script prints, and reaches the exit codes. Read
  # once into a variable: piped into grep -q, whatever writes the help can be killed by
  # SIGPIPE at the first match, and pipefail would call that a failure
  local help
  help=$(skill --help)
  grep -q '^Exit 1 with' <<<"$help" || fail "--help stops before the exit codes"
  # An id is the first word of a scan call, the third word of a direct warn call, or the
  # first argument of a prose rule r("ID", …); the count guards the extraction, since a
  # grep that matches nothing would hold the help to nothing. A prose rule's message comes
  # from why(), so every such id also needs its arm there, or it warns with no reason
  local ids rule_ids
  rule_ids=$(grep -oE '^ *r\("[a-z-]+"' check-skill.sh | sed 's/.*"\([a-z-]*\)"$/\1/' | sort -u)
  [[ -n "$rule_ids" ]] || fail "no prose rule r(\"ID\", …) was found in check-skill.sh, so the extraction is broken"
  for id in $rule_ids; do
    grep -qE "^ +$id\) echo " check-skill.sh || fail "the prose rule '$id' has no message in why()"
  done
  ids=$({
    grep -E '^ *scan [a-z-]+' check-skill.sh | awk '{ print $2 }'
    grep -E '^ *warn ' check-skill.sh | awk '{ print $4 }' | grep -E '^[a-z-]+$'
    printf '%s\n' "$rule_ids"
  } | sort -u)
  [[ "$(wc -l <<<"$ids" | tr -d ' ')" -ge 14 ]] || fail "only these warning ids were found in check-skill.sh, so the extraction is broken: $ids"
  for id in $ids; do
    grep -qE "^  $id " <<<"$help" || fail "the warning id '$id' is printed by check-skill.sh but not named in its help"
  done
  # A warning is stdout only, with the exit code untouched, until --strict; then it is a
  # finding on stderr and the run is red. The gates that run this script on a planted copy
  # read the first stderr line as the reason the copy failed — DEVIATIONS.md
  c="$work/warned"
  mkdir -p "$c"
  tar --exclude=.git -cf - . | tar -xf - -C "$c"
  printf '\n## Layout\n' >>"$c/SKILL.md"
  status=0
  out=$(CHECK_SKILL_NESTED=1 skill -n "$skill_name" "$c" 2>"$work/stderr") || status=$?
  ((status == 0)) || fail "a planted warning changed the exit code to $status — a warning must leave a consumer's gate green"
  grep -q '^check-skill: warning: SKILL.md:[0-9]*: layout-section' <<<"$out" || fail "the planted Layout section was not warned about on stdout: $out"
  [[ ! -s "$work/stderr" ]] || fail "a warning reached stderr without --strict, where a consumer's gate would read it as a finding: $(cat "$work/stderr")"
  status=0
  out=$(CHECK_SKILL_NESTED=1 skill --strict -n "$skill_name" "$c" 2>"$work/stderr") || status=$?
  ((status == 1)) || fail "a planted warning under --strict exited $status, not 1"
  grep -q '^check-skill: SKILL.md:[0-9]*: layout-section' "$work/stderr" || fail "under --strict the warning did not reach stderr as a finding: $(cat "$work/stderr")"
  grep -q 'under --strict' "$work/stderr" || fail "under --strict the run did not say why it is red: $(cat "$work/stderr")"

  # check-skill.sh claims bash 3.2, and a grep for newer syntax is a proxy; the mechanism
  # is this half under the real 3.2, with two constructs planted that only a 3.2 rejects.
  # Under a newer bash they are no defect at all, so this block runs only where
  # CHECK_BASH32 says which bash this is, and first checks that claim
  if [[ -n "${CHECK_BASH32:-}" ]]; then
    echo "== this bash is the 3.2 the proof is about"
    ((BASH_VERSINFO[0] == 3)) ||
      fail "CHECK_BASH32 is set, but this is bash $BASH_VERSION — on macOS, run: /bin/bash ./check.sh behaviour"
    ! "$BASH" -c 'declare -A m' >/dev/null 2>&1 || fail "CHECK_BASH32 is set, but this bash accepts declare -A"
    # Both plants go right after the set line and exit 70 when refused, so a refused
    # builtin is told apart from every code the script exits with on its own
    local plant
    for plant in 'declare -A check_skill_probe' 'mapfile -t check_skill_probe </dev/null'; do
      awk -v line="$plant || exit 70" '{ print } /^set -[a-z]*o pipefail$/ && !done { print line; done = 1 }' \
        check-skill.sh >"$work/probe.sh"
      grep -qF "$plant || exit 70" "$work/probe.sh" || fail "the plant '$plant' did not land in check-skill.sh"
      status=0
      CHECK_SKILL_NESTED=1 "$BASH" "$work/probe.sh" -n "$skill_name" . >/dev/null 2>&1 || status=$?
      ((status == 70)) || fail "a check-skill.sh running '$plant' ran under this bash (got $status) — this is not a 3.2"
    done
  fi
}

case "$mode" in
  lint) check_lint ;;
  behaviour) check_behaviour ;;
  all)
    check_lint
    check_behaviour
    ;;
esac

echo
echo "check: everything holds"
