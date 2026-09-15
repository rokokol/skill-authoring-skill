# The description, the triggers and the harness

The description is the only part of a skill every conversation reads. It decides whether the skill loads at all, so it is written for the matcher and for the person who scans a list of skills, in that order

## Shape

Three parts, in one string: what the skill is, when to use it, and the triggers. "What it is" is one sentence that lets a reader tell this skill from its neighbours. "Use when" names the situations, the sub-steps included: a skill about changelogs loads when a changelog entry is written inside a larger task, not only when the task is about changelogs. The triggers close the description

The loader caps the description; the gate counts characters rather than bytes, so a trigger in a non-Latin script costs its length, not three times it

## Triggers from real speech

- **A trigger is a phrase the user actually types**, in each language they write, with its natural word order and its shortcuts: "перенеси на пятницу", "поправь readme", "how are you", "did CI pass". A description is matched by meaning, so the phrase that appears in ordinary speech is the one that matches
- **Never an interview question.** "Who are you", "describe your character", "tell me about yourself" are what nobody writes; a persona skill loads on "помнишь", "мне тяжело", "как дела", the phrases that carry the emotional and support cases the skill exists for
- **No spelling variants of one word.** "obsidian cli / obsidiancli / obsidian-cli" in one list is three tokens for one meaning; the matcher already covers them, and each variant occupies every request that lists the skill. One spelling per word, the one the user uses
- **A trigger must lead somewhere that exists.** A description that names a binary the skill does not ship, an option a command lacks or a file the repository never had sends the agent to a dead end while reading as capability. The same check applies before installing someone else's skill: read what it promises against what it contains, and only then install
- **A skill not loading on a sub-step is not a keyword problem.** When an edit to a README, a changelog or a workflow happens inside a larger task, the description matched and the skill still did not load. Tuning triggers does not change that; the rule that the agent loads a skill before any action its description names belongs to the agent's instructions, once, and not to every skill's trigger list

## Prompt hygiene

- **An example names `<model>`.** The agent copies an example verbatim, so `claude-<family>-<n>` in a commit trailer or an API call pins every user to that release. A placeholder is copied as a placeholder and filled in by the agent that knows which model it is
- **No idiom of old prompts.** `MUST` and `CRITICAL` in capitals, `take a deep breath`, `comprehensive`, `Red Flags - STOP`: each was a way to shout at a model that needed shouting at. A current model reads emphasis as a signal that something is unusual, so emphasis is used once, where something is, and carries its reason on the same line
- **No instruction to check again, and no scheduled reviewer.** `Double-check your work`, `verify your answer`, `have a subagent review the result`: the model already verifies as it works, so the line only costs tokens, and a second agent's run is a price the user chooses to pay, by asking for a review, never a step the skill prescribes
- **A rule and its reason on one line**, the mechanism in a reference. A rule without its reason is followed to the letter and broken in point

## Portability

A skill is a directory with a `SKILL.md`, and that format is an open standard read by more than one harness. Every skill works in any of them unless it genuinely cannot, and the text says so only when it is true

- **Name the class, not one harness's file.** "The agent's instructions (CLAUDE.md, AGENTS.md…)" and "the harness's own memory" describe what every harness has; `CLAUDE.md` alone describes one. A harness-specific path may appear as an example of the class, never as the rule
- **A plugin manifest is an install channel, not a dependency.** A skill installable as a plugin is still a directory with a `SKILL.md`; the manifest adds a way in and takes nothing away
- **A harness badge only where the skill cannot work without that harness.** The README's badge row opens with the Agent Skill badge, `[![Agent Skill](https://img.shields.io/badge/Agent_Skill-6E56CF?style=flat)](https://agentskills.io)`; a harness badge beside it claims a dependency, and a claimed dependency that does not exist is a lie the reader acts on
- **Capabilities, not tool names.** A skill that needs a subagent, a web fetch or a persistent memory names the capability and lets the harness supply its tool; a hard-coded tool name works in one harness and reads as an error in the next
