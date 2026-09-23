# Changelog

Kept in the shape of [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), dated rather than numbered, and with no `Unreleased` section: this repository is read at whatever revision you have checked out, so whatever is on the default branch is what every reader already has

## 2026-09-23

### Fixed

- `check-skill.sh` claimed "POSIX tools only" in its header while calling `git` for the repository's own origin, which `--install` uses and does without. The header names `git` now, so the claim matches the script; `check-sh.sh` reads that line and had begun to say so

## 2026-09-22

### Added

- `check-prose.sh`, vendored from [create-readme](https://github.com/rokokol/create-readme-skill), replaces the two prose rules this gate carried as its own awk. Five repositories held that copy in two spellings that had drifted apart, and the vendored file decides more than they did: the admonition shape, a typographic quotation mark and a heading that duplicates a file
- two rules over the readme's install section, in [references/description.md](references/description.md) under `Portability`: every channel a readme offers ends in the reader's own skills directory, and a channel the readme offers is a channel the repository carries. A clone into some other directory is readable only through a symlink, which is one skill in two places and a path named for the author's machine
- `check-skill.sh` warns with `install-elsewhere` when a clone under the install heading lands outside a skills directory, and with `plugin-promise` when the readme offers `/plugin marketplace add` for this repository and `.claude-plugin/marketplace.json` is not in it. A marketplace in another repository is not decided: nothing here reaches the network
- `check-skill.sh --install` prints the readme's install section for a repository, so the same three channels are generated rather than copied by hand. `--marketplace OWNER/REPO@NAME` names a marketplace living elsewhere; without it, the plugin block appears only where the repository carries the manifest itself, and the template's own output is read back through both new rules on every run

## 2026-09-18

### Changed

- the house rules cover the agent's own instructions — `CLAUDE.md`, `AGENTS.md`, the harness's memory — as well as a skill: runtime under a harsher rule, loaded into every conversation rather than the ones that reach for the topic, and with no description or trigger to earn their way in. The description fires on a change to them, and `check-skill.sh` is unchanged, since it checks a skill repository

### Fixed

- `check-skill.sh` read SKILL.md's frontmatter through `printf … | awk`, and that awk program exits as soon as it has the value it was asked for. A producer whose reader stops early dies of SIGPIPE, and `pipefail` makes that the status of a pipeline that did its job, so the checker could fail on a frontmatter carrying every key it asks for. The text reaches awk through `<<<` now, which has no producer to kill

### Added

- a rule that a caveat changing no action is provenance, in `SKILL.md` under the evidence heading, with `Confidence is not a bound` in [references/evidence.md](references/evidence.md) beside the rule about dates and tool versions it distinguishes itself from. A bound stays because crossing it changes what the agent does; the author's confidence never does, so a sample size or a `revisit if more data appears` is billed on every load and reads as permission to treat the rule as optional
- `Before a line goes into runtime`, four questions closing `SKILL.md`. The rules are grouped by topic and a line being written does not announce its topic, so the questions are the other way in, by the moment the decision is made; each routes to a rule above and states none of its own
- a rule for a line that has to survive a harness instruction: the harness's own instructions arrive later and can claim to replace earlier guidance, so a rule that only states itself is dropped and one that names which lines the harness's instruction reaches holds. Length beyond that naming does not hold it better
- the dev shell carries `jq`, ahead of the checker that will need it: the vendored `check-sh.sh` is moving off its awk lexer to reading the script it is given as a tree, out of `shfmt --to-json`, with jq flattening that tree into the rows its rules read. It lands before the cascade delivers that checker, so a new copy does not arrive to a missing tool and a red verify

## 2026-09-17

### Fixed

- `check-skill.sh`'s header said where the file comes from in a sentence with no subject — `From <url>, never edits its copy in place` — and pointed at an antecedent that had moved into the help, `There the falsification proves nothing new`. It now names the cascade whole, and the sentence about a copy's falsification is gone from the header, which the help already carries under `CHECK_SKILL_NESTED`
- `check-skill.sh`'s help no longer repeats where the file comes from: that fact belongs to the header alone, and the help keeps only what a caller acts on, that the script has no repo-specific part and belongs in a repository's own gate
- two paragraphs of `check-skill.sh --help` ended with a full stop, the `-n NAME` sentence and the network line, where the house rule leaves the last line of a paragraph bare

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
