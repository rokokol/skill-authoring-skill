# Evidence, not provenance

A skill is a rule, not a memory. A memory records where something happened; a rule tells the agent what to do now and why it is true. Runtime keeps the second and hands the first to git

## What a rule keeps

- **The rule**, stated as acting: "warnings go to stdout", never "warnings no longer go to stderr". A reader who arrives at the current text has nothing to compare "no longer" with
- **The mechanism**: why the rule is true, separated from assumptions
- **A minimal reproduction and its observable result**, when the rule rests on measured behaviour: the command and what it printed, so the next reader re-measures rather than believes
- **A verified primary source**, when the rule rests on a document: the manual, the standard, the upstream policy, cited after it was read
- **A measurement date or a tool version**, when it bounds the validity of a result: "under Jest 30", "measured on bash 3.2.57". A date that only says when a defect was found bounds nothing and goes

## What goes to git and the changelog

- Discovery history: which audit found the problem, in which session, on which day
- The names of repositories or checkers that once failed on the rule. Knowing which gate broke does not help apply the rule, and the name outlives the incident
- Pseudo-citations into another checkout: `other-repo/path:line`. The checkout may be absent on the consumer's machine, the line drifts on the first edit, and the citation then points at nothing while reading as evidence. A resolvable local link between two runtime references stays, because it lands on the one place that holds the mechanism
- `used to`, `previously`, `formerly`, and the story of how the current text replaced the old one

The changelog records that the change happened and the commit body records why. Runtime records only what is true now

## What a source is

A `sources.md` reference, where a skill keeps one, holds only primary sources that were successfully read: the manual page, the standard, the upstream policy document, the measurement. It is not a table of neighbouring repositories the rules were mined from, and not a list of adjacent skills

- **A URL verifies nothing by itself.** A claim is published after its source was read; if the fetch failed, the claim is removed or parked as an unfinished task outside the artifact until the source can be checked
- **Never write a fetch-failure note beside a claim.** `fetch failed while writing this; the page is the canonical location` tells the reader the skill is teaching an unchecked statement and calls it a citation
- **Dependency provenance is development text.** Which repository a vendored checker comes from, which skill's harness a script was adapted from: a script comment, the README's development section, a maintainer document or the vendor lock, where the reader needs it to update the copy. There it is a direct URL, not a bare skill name, because a name cannot be followed

## Private repositories

A public skill never uses a private repository as a runtime source or as a style dependency. The consumer of the skill cannot read it, so a rule that depends on it is unverifiable and a style that points at it is a dead link. The order is local style first: the repository the agent is working in sets the shape. Then a self-contained default the skill spells out. A private path may appear only as a configuration the user owns, never as the rule

## External policies and interfaces

- **A table of external policies is not ranked into one strictest default** when their formats are incompatible. Each form is held to its own current primary document; a synthesis that satisfies none of them is not a stricter rule but a wrong one
- **The version of an external interface is a development snapshot**, committed with the version it was recorded from and diffed by the gate against the installed artifact when one is present. Runtime states the semantics that hold now; it does not narrate when they appeared or what the interface looked like before
