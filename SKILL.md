---
name: skill-authoring
description: "What it is — the house rules for writing a skill, and check-skill.sh, the gate that checks one. Use before any change to a skill: creating one, editing its SKILL.md, a reference or its description, reviewing or installing one. Triggers: skill, SKILL.md, new skill, fix the skill, review this skill, the skill does not load, скилл, напиши скилл, поправь скилл, отредактируй скилл, проверь скилл, скилл не подгружается."
license: MIT
---

# skill-authoring

A skill is loaded whole into every conversation that reaches for it, so each line either helps the agent act now or costs every future request. Two kinds of text live in a skill's repository. **Runtime** is `SKILL.md` and everything under `references/`: the only files an agent loads. **Development** is the README, the changelog, maintainer documents, script and workflow comments, vendor locks and tests: what a person reads while working on the repository. Every rule below says which side a line belongs to

[`check-skill.sh`](check-skill.sh) beside this file decides the machine-checkable half, on any skill repository: what stops a skill loading is an error, and the rest of the rules are warnings that draw attention without turning a gate red. `check-skill.sh --help` is the reference for what it checks, how a line is excused and how warnings become errors

## The boundary

- **Runtime holds what an ordinary invocation needs.** Install, repository development, self-tests and checkout layout belong to the README or a maintainer document; a `Layout` section in runtime is README content billed on every load. See [references/boundary.md](references/boundary.md)
- **A tool is not restated; it is pointed at.** Runtime sends the agent to the tool's own help and mentions only the calls the task needs, each of which must exist there. Two accounts of one interface disagree within a month
- **Principle and mandatory action in `SKILL.md`, the mechanism in one reference.** Every file under `references/` is reachable by a chain of links from `SKILL.md`; a reference nothing links to is never read and rots while looking maintained. When a link goes, either another route remains or the file goes with it
- **Runtime never says which sibling skill owns another topic.** Routing is the agent's instructions' job, and a link to a neighbour makes the skill depend on a checkout that may not exist. The one candidate exception is a skill that itself defines a composite standard and imports another standard whole; even then the exact link is shown to the user and added only on their decision. See [references/boundary.md](references/boundary.md#the-two-exceptions)

## Evidence, not provenance

- **A rule is written as acting.** It keeps the rule, the mechanism, a minimal reproduction, the observable result and the verified primary source where one is needed. Discovery history, the names of repositories or checkers that once broke, incident dates and `used to` belong to git and the changelog. See [references/evidence.md](references/evidence.md)
- **No pseudo-citation into another checkout.** `other-repo/path:line` assumes a checkout that may be absent and a line that drifts; a resolvable local link between two references is fine, because it lands on the one place that holds the mechanism
- **A source is cited only after it was read.** A note that the source could not be reached does not verify the claim beside it. An unverified claim is removed or parked as an unfinished task outside the artifact. See [references/evidence.md](references/evidence.md#what-a-source-is)
- **A public skill never reads a private repository at runtime.** Local style first, then a self-contained default; a private path may only stand as a configuration the user owns

## Description and triggers

- **Triggers are what the user actually says.** Ordinary speech in each language the user writes, the support cases for a persona included, never interview questions and never spelling variants of one word: the description is matched by meaning, and variants only occupy every request. See [references/description.md](references/description.md)
- **An example names `<model>`, not a model.** The agent copies an example verbatim, so a concrete id pins every user to that release
- **No idiom of old prompts.** A capitalised `MUST`, `take a deep breath`, `comprehensive`, `Red Flags`: emphasis is used once and carries its reason. See [references/description.md](references/description.md#prompt-hygiene)
- **A skill works in any Agent Skills harness.** Name "the agent's instructions (CLAUDE.md, AGENTS.md…)" and "the harness's own memory" rather than one harness's file; a harness path appears as an example, never as the rule. See [references/description.md](references/description.md#portability)

## Review

- **A review happens when the user asks for one, and then it is never one's own.** A skill never tells the agent to check its work again or to hand it to a reviewing agent: the model verifies as it works, and a written `double-check` costs tokens and changes nothing. When the user asks, a fresh separate agent reviews, never the author and never a fork, which inherits the assumptions the review must test; the house rules go into its prompt, it finds defects and edits nothing, and every finding is verified before it is shown. See [references/review.md](references/review.md)
- **An audit is one repository at a time, with a visible diff**, and it ends with the list of what was considered for removal and consciously kept. A mass edit erases authorship and exceptions; when one has happened, restore the baseline first
- **A gate can guard the wrong copy, and a red tool can be wrong.** Before trusting either, check the second copy it compares against and the regex it was given. See [references/review.md](references/review.md#gates-and-tools)
- **One evaluation pass at most.** Once a skill works in real use, the user judges by use; a second with-and-without run is tokens spent on a question already answered

Following the letter of a rule while breaking its point is breaking the rule; the rules are short so the point can be read
