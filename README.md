<div align="center">

# skill-authoring skill

**How a skill of the family is written, and the gate that checks it 🧭**

[![Agent Skill](https://img.shields.io/badge/Agent_Skill-6E56CF?style=flat)](https://agentskills.io)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnubash&logoColor=white)
![Nix](https://img.shields.io/badge/Nix-flake-7EBAE4?style=flat&logo=nixos&logoColor=white)
[![license](https://img.shields.io/badge/MIT-3DA639?style=flat)](LICENSE)
[![deviations](https://img.shields.io/badge/docs-deviations-555?style=flat)](DEVIATIONS.md)
[![pitfalls](https://img.shields.io/badge/docs-pitfalls-555?style=flat)](PITFALLS.md)
[![ci](https://github.com/rokokol/skill-authoring-skill/actions/workflows/build.yml/badge.svg)](https://github.com/rokokol/skill-authoring-skill/actions/workflows/build.yml)
[![macos](https://github.com/rokokol/skill-authoring-skill/actions/workflows/macos.yml/badge.svg)](https://github.com/rokokol/skill-authoring-skill/actions/workflows/macos.yml)

</div>

A skill is loaded whole into every conversation that reaches for it. Each line either helps the agent act or costs every future request, and the lines that cost are rarely the ones that look expensive: a `Layout` section, a link to a sibling skill, a sentence that says what the text used to say, a trigger nobody would type

This skill is the set of rules that keep a skill worth loading, gathered from an audit of every skill in this family, plus a checker that decides the half a script can decide. The rules are in [SKILL.md](SKILL.md), one line each with a link to the reference that argues it, kept where the agent reads them rather than as a second copy here

## Contents

- [Install](#install)
- [The checker](#the-checker)
- [Tests](#tests)
- [Layout](#layout)

## Install

```sh
git clone https://github.com/rokokol/skill-authoring-skill ~/Projects/skill-authoring
ln -s ~/Projects/skill-authoring ~/.claude/skills/skill-authoring
```

Or straight into the skills directory your agent reads:

```sh
git clone https://github.com/rokokol/skill-authoring-skill ~/.claude/skills/skill-authoring
```

> [!NOTE]
> This repository has no version: `git pull` is the whole upgrade path, and its changelog is dated rather than numbered

## The checker

[`check-skill.sh`](check-skill.sh) takes **any** skill repository, which is what makes it worth more than a review comment: drop it into a repository's own gate and the rules stop depending on somebody remembering them

```sh
check-skill.sh -n NAME .          # NAME is what the readme and the install symlink call the skill
check-skill.sh --strict -n NAME . # every warning is a finding
```

Two tiers. What stops a skill loading at all, or leaves a reference unread, is an **error**: malformed or oversized frontmatter, a file under `references/` no chain of links from `SKILL.md` reaches, a link or a heading anchor that resolves to nothing. It exits 1 on the first one. The rest of the rules are **warnings**, printed on stdout as `check-skill: warning: FILE:LINE: what` without changing the exit code, so a consumer's gate stays green while attention is drawn: a `Layout` or install section in runtime, `used to` and its relatives, a `path:line` citation into another checkout, a discovery date, a link to a sibling skill, one harness's file named as the rule, an idiom of old prompts, a concrete model id in an example, an instruction to re-check the work or to hand it to a reviewing agent, a fetch-failure note, a trigger listed twice, a README whose badge row does not open with the Agent Skill badge or carries a harness badge. A line that is right for a reason is excused in `check-skill.allow` beside the checker, a file no agent loads, so the excuse costs no tokens: one entry per line, `ID PATH [TEXT]`, and an entry that excuses nothing is an error, since it would swallow the next real violation on that path; `--strict` turns the warnings into findings. `check-skill.sh --help` is the reference for all of it

Every check, error or warning, proves itself able to fire on every run: the script copies the repository, plants one defect per check, and requires itself to go red, or to warn, for that defect's own reason, with an excused copy of each plant that must stay quiet. That is why a copy of the file can travel to another repository on its own: it is falsified in the repository that runs it, each time

The checker needs bash 3.2 and POSIX tools only, so it runs on a macOS runner unchanged. Another repository takes it through the vendoring cascade rather than by hand, so a fix made here reaches every copy

## Tests

```sh
nix develop -c ./check.sh
/bin/bash ./check.sh behaviour   # under the bash macOS ships, as the macos workflow runs it
```

Lints what the repository ships, runs actionlint over the workflows and demands that it reject the known-bad one in `tests/fixtures/`, holds every vendored copy to its lock and every workflow to the pin guard, and checks that no paragraph in the docs is hard-wrapped or ends on a full stop. Then it holds `check-skill.sh` to its own header with the vendored `check-sh.sh`, runs it under `--strict` on this repository, the first skill it has to be right about and the one held to its own warnings as errors, and probes what the checker's self-falsification cannot: that `-n` without a name exits 2 rather than 1, that every warning id the script prints is named in its help, that a planted warning leaves the exit code at 0 and stderr empty, and that the same copy under `--strict` goes red with the warning on stderr. On the macOS runner the behaviour half runs under the real `/bin/bash` 3.2, with constructs planted that only a 3.2 rejects

The gate, vendored checkers and workflows are the family's shared machinery: `vendor-sync.sh`, `check-pins.sh` and the cascade workflow come from the [ci](https://github.com/rokokol/ci-skill) skill, `check-sh.sh` and the macOS workflow from the [bash-best-practices](https://github.com/rokokol/bash-best-practices-skill) skill, each held byte-equal to its source by `.github/vendor.lock`

## Layout

```
SKILL.md              the rules an agent reads
references/           boundary (runtime vs development), evidence (not provenance), description (triggers, hygiene, portability), review (agents, audits, gates)
check-skill.sh        the checker, which takes any skill repository
check.sh              the self-testing gate
check-pins.sh         the pin guard for the workflows, vendored from the ci skill
check-sh.sh           holds check-skill.sh's help to its code and its bash 3.2 claim to a proxy grep, vendored from the bash-best-practices skill
vendor-sync.sh        keeps the vendored copies byte-equal to their source, vendored from the ci skill
tests/fixtures/       the known-bad workflow actionlint must reject
DEVIATIONS.md         why warnings go to stdout
PITFALLS.md           the traps met on the way, with the way through each
```
