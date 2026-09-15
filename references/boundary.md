# The boundary between runtime and development

An agent loads `SKILL.md` when the description matches, and a reference when `SKILL.md` sends it there. Nothing else in the repository reaches a conversation. That is the whole basis of the boundary: a line in runtime is paid for on every load, and a line outside runtime is free until a person opens the file

## What runtime holds

- **Knowledge and actions needed at an ordinary invocation.** The rules, the mechanism behind each, the commands the task calls and the errors it must recognise
- **Not install or setup of the repository.** A clone, a symlink, a plugin manifest, a dependency list: the README's. The agent that has loaded the skill is past install by definition
- **Not development.** How the gate runs, what the tests plant, which files are vendored from where: the README's `Tests` section, the gate's own comments and the vendor lock
- **Not the checkout's layout.** A `Layout` section lists files a person navigates; the agent follows links. Its home is the README, and a runtime copy is a second list that drifts and a permanent context cost

## A tool is pointed at, not restated

Runtime that teaches a CLI, an API or an MCP server sends the agent to that tool's own help and mentions only the calls the task at hand needs. The full interface restated in `SKILL.md` is a second source of truth: the code changes, the restatement does not, and the agent learns a call that no longer exists. The mentions that remain are held to the tool one-way, every mentioned call must exist, never the reverse, since a document that mentions some of a tool is not obliged to mention all of it

## Core and references

`SKILL.md` carries the principle and the mandatory action, one line each; the detailed mechanism lives in exactly one reference that the line links. The split keeps `SKILL.md` short enough to load on every match and lets the mechanism be read only when the agent is about to apply it

Reachability is transitive: `SKILL.md` may delegate to a reference that links on. A file under `references/` that no chain of links reaches is never loaded, so it rots while looking maintained; the gate treats it as an error. After removing a link, either another thematic route to the file remains or the file is deleted as the dead weight it has become. Only a link counts, not the file's name in prose, and only a link from runtime: a link from the README reaches nothing, because an agent does not load the README

## No routing to a sibling

Runtime never says which other skill owns an adjacent topic. Two reasons, either sufficient:

- **Routing belongs to the agent's instructions**, which know which skills are installed. A skill that routes assumes a neighbour is present and repeats, in every skill, a table the instructions already hold once
- **A link to a neighbour is a dependency on a checkout.** The link resolves on the author's machine and on none of the machines the skill is copied to

The removal is the default, and it is applied to prose, to `See also` lines and to comparison tables alike. What the current skill needs from the neighbour's doctrine, it states in its own words, as its own specialisation

## The two exceptions

- **A composite standard.** A skill that defines a standard and imports another standard whole, adding only its own specialisation beside it, is incomplete without the import. Even then the link is not kept or added on the author's judgment: the exact link and what it imports are shown to the user, who decides. Elegance is not approval, and a link that survived in another repository is not precedent
- **An operational bootstrap of private state.** A token, a private home directory, a credential the user writes once: when the ordinary invocation is impossible or unsafe without it, the bootstrap lives in runtime, because the agent has to perform it at the first call. This is not repository install; it is the first step of use, and it never places the secret itself in a command line, a task or a file the repository tracks

A **self-editing template** is the same exception seen from the other side: a template whose `SKILL.md` instructs the agent to rewrite that very `SKILL.md` into its configured form may keep those instructions in runtime, provided a falsifiable gate requires them in the template and rejects them in a configured fork. The instructions transform the skill itself and disappear once it is configured; that is what separates them from install text
