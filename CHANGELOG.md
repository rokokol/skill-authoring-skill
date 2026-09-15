# Changelog

Kept in the shape of [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), dated rather than numbered, and with no `Unreleased` section: this repository is read at whatever revision you have checked out, so whatever is on the default branch is what every reader already has

## 2026-09-15

### Added

- the skill: how a skill of this family is written, in `SKILL.md` and four references, gathered from the rules an audit of every family skill confirmed and from the agent's private memory, which they replace
- `check-skill.sh`, the gate a skill repository runs, moved here from the [ci](https://github.com/rokokol/ci-skill) skill's templates, where its origin was, so that the rules and the checker that decides them live in one repository; consumers take it through the vendoring cascade from here
- a warning tier in `check-skill.sh`: the rules that do not stop a skill loading are reported as `check-skill: warning: FILE:LINE: what` on stdout without changing the exit code, a line excused in `check-skill.allow` beside the checker is not reported, an excuse that excuses nothing is reported as `stale-allow`, and `--strict` turns every warning into a finding. Each warning is proven able to fire on a planted defect, and to stay quiet on its excused line, on every run
- `check.sh`, the gate: lint of everything the repository ships, the vendored copies held to their lock, the docs held to the family's one-paragraph-per-line and no-trailing-full-stop rules, `check-skill.sh` held to its own header and run on this repository, and its `-n` usage probe, which the ci skill's gate ran while it owned the file
- `DEVIATIONS.md`, recording why warnings go to stdout rather than stderr, and `PITFALLS.md`, recording that macOS collates Cyrillic strings as equal and `uniq` compares in that collation

### Changed

- a review by a fresh agent is something the user asks for, not a step a skill prescribes: `SKILL.md`, `references/review.md` and `references/description.md` say that a skill never tells the agent to re-check its work or to hand it to a reviewing agent, since the model verifies as it works and the line only costs tokens; `check-skill.sh` warns on such a line as `recheck-instruction`

### Fixed

- `check-skill.sh` could reject a repository for a heading anchor that exists, or end a run without a word: the anchors were piped straight into `grep -q`, which stops reading at the match, and under `pipefail` the writer's SIGPIPE read as a failure. The anchors are read into a variable first, and the same shape is kept out of every new check
- on macOS, trigger-duplicate reported `скилл` and `новый скилл` as listed twice in a description that lists each once: `uniq -d` there compares in the locale's collation, where Cyrillic strings collate equal. The triggers are compared as bytes
