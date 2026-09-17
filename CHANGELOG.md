# Changelog

Kept in the shape of [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), dated rather than numbered, and with no `Unreleased` section: this repository is read at whatever revision you have checked out, so whatever is on the default branch is what every reader already has

## 2026-09-17

### Changed

- The description is cut to what the skill is, the actions that load it and the phrases users type for them: any change to a skill — creating one, editing its `SKILL.md`, a reference or its description, reviewing or installing one — now loads it, and the table of contents of the rules is gone from the description
- `check-skill.sh --help` says when a gate may set `CHECK_SKILL_NESTED=1`: inside copies of its own repository and on every call after the first in one run, never on the first, because the defects are planted into a copy of the repository being checked and what the self-test proves changes with it

## 2026-09-16

### Changed

- `check.sh` no longer parses every script with its own `bash -n` loop: `check-sh.sh` reports a script it cannot parse, and the gate hands it this repository's own scripts, itself included. The vendored copies are byte-equal to sources that parse them there, which `vendor-sync.sh` and the lock guarantee

### Fixed

- `check-skill.sh` matched SKILL.md's frontmatter through `printf … | grep -q` and took the description's line number through `| head -n 1`: a reader that stops early closes the pipe, whatever feeds it dies of SIGPIPE, and `pipefail` makes that death the status, so the checker could fail on a frontmatter that carries every key it asks for. The text reaches `grep` through `<<<` now, and the line number through a `sed` that reads to the end — the mechanism is measured in the [bash-best-practices](https://github.com/rokokol/bash-best-practices-skill) skill's `references/pitfalls.md`. The frontmatter's opening `---` is read the same way, where `head` writes its one line and leaves nothing to kill: the rule holds for every reader that stops early, and `check-sh.sh` now reports the shape, so a checker spelling its own exception would be one nobody can hold to it

## 2026-09-15

### Added

- the skill: how a skill of this family is written, in `SKILL.md` and four references, gathered from the rules an audit of every family skill confirmed and from the agent's private memory, which they replace
- `check-skill.sh`, the gate a skill repository runs, moved here from the [ci](https://github.com/rokokol/ci-skill) skill's templates, where its origin was, so that the rules and the checker that decides them live in one repository; consumers take it through the vendoring cascade from here
- a warning tier in `check-skill.sh`: the rules that do not stop a skill loading are reported as `check-skill: warning: FILE:LINE: what` on stdout without changing the exit code, a line excused in `check-skill.allow` beside the checker is not reported, an excuse that excuses nothing is an error, as `check-interface.sh` treats its own, and `--strict` turns every warning into a finding. Each warning is proven able to fire on a planted defect, and to stay quiet on its excused line, on every run
- `check.sh`, the gate: lint of everything the repository ships, the vendored copies held to their lock, the docs held to the family's one-paragraph-per-line and no-trailing-full-stop rules, `check-skill.sh` held to its own header and run on this repository, and its `-n` usage probe, which the ci skill's gate ran while it owned the file
- `DEVIATIONS.md`, recording why warnings go to stdout rather than stderr, and `PITFALLS.md`, recording that macOS collates Cyrillic strings as equal and `uniq` compares in that collation

### Changed

- `check-skill.sh` prints its help from a heredoc instead of reading its own header back, which under `bash <(…)` is the pipe bash reads the script from and printed nothing; the network and bash 3.2 claims stay in the header comment and are no longer part of `--help`
- a review by a fresh agent is something the user asks for, not a step a skill prescribes: `SKILL.md`, `references/review.md` and `references/description.md` say that a skill never tells the agent to re-check its work or to hand it to a reviewing agent, since the model verifies as it works and the line only costs tokens; `check-skill.sh` warns on such a line as `recheck-instruction`
- `check-skill.sh`'s header now keeps only what an editor needs — where the file comes from, the bash 3.2 floor, why nesting skips the self-falsification — and its `--help` carries everything a caller acts on, the network line included, which an entry earlier today left in the header; `check.sh`, the gate, answers `--help` too, with its two modes, what each needs and its exit codes

### Fixed

- `check-skill.sh` could reject a repository for a heading anchor that exists, or end a run without a word: the anchors were piped straight into `grep -q`, which stops reading at the match, and under `pipefail` the writer's SIGPIPE read as a failure. The anchors are read into a variable first, and the same shape is kept out of every new check
- on macOS, trigger-duplicate reported `скилл` and `новый скилл` as listed twice in a description that lists each once: `uniq -d` there compares in the locale's collation, where Cyrillic strings collate equal. The triggers are compared as bytes
- a run of `check-skill.sh` cost about twice what it did before the warning tier, and a gate that runs it inside copies of its own repository paid that again in every copy: the tests skill's job hit its 15-minute limit. The rules over prose run in one awk pass per document instead of a process per rule, and a relative link is resolved only when it climbs with `..`, the only way out of the repository; on the tests skill a run takes 63 s where it took 107 s, with the same warnings on every consumer. `--help` now names `CHECK_SKILL_NESTED=1`, which skips the self-falsification, for such a gate to set inside its copies
