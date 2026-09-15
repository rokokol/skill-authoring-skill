# Review, audits and the tools that judge them

A skill is read by a model, so its defects are the defects a model does not notice in its own writing: a rule that reads well and cannot be applied, a link that lands on nothing, an example that pins every reader to one release. The review that catches them is arranged so that the hand that wrote the text is never the hand that grades it

## Review by a fresh agent

- **Never oneself.** The author re-reading finds what the author already believes
- **Never a fork.** A fork inherits the author's context and with it every assumption the review is supposed to test; it agrees for the same reasons the author did. A fresh agent starts from the text alone
- **The house rules go into the prompt.** A generic reviewer suggests the conventions it was trained on: third-person descriptions, a full stop on every bullet, a section per file. Given the repository's rules, it holds the text to those instead and lists the conflicts between its defaults and the rules as a separate list rather than as findings
- **Agents find, people and the author fix.** A reviewing agent is read-only. It reports "file, line, what is wrong, what it costs, the fix, verified or assumed"; the change is made afterwards, with a visible diff, by whoever owns the text
- **Every finding is verified before it is shown.** The critical ones are checked against the file, the tool and a run; a count is recounted. A finding relayed unverified is a claim the reviewer made and the relay now owns
- **After a mass edit, run the gate.** Every "file → section" reference lands on an existing heading or the gate says which does not; a moved heading leaves a link that reads fine and resolves to nothing

## Audits

- **One repository at a time, with a visible diff.** The audit of a family of skills is a sequence of small audits, each reviewed and committed on its own. A mass edit across repositories erases authorship and the exceptions each repository kept for a reason; when one has happened, the baseline is restored first and the audit repeated repository by repository
- **The audit ends with what was kept.** Every candidate for removal that was considered and consciously left in place is listed at the end, with its reason. The next audit then starts from the decisions rather than rediscovering them
- **Removing a link is not removing a dependency.** After a runtime link goes, the same target may remain in script comments, templates, workflow files and vendor locks. Those are development text: they keep the link, as a direct URL, because a person updating the copy needs it

## Gates and tools

- **A gate can guard the wrong copy.** A check that compares two files byte for byte enforces that the second copy exists. When the rule moves one of them out of runtime, the comparison must go with it, or the gate quietly demands the duplicate the rule just forbade. A document that mentions some of a tool's calls is checked one-way against the tool, never against the tool's full list
- **A red tool is read after its input.** Before suspecting the tool, check the query it was given against the decisions already made: a search pattern with a construct the engine does not support fails as a match on nothing and reads as a clean result, or as a finding on everything
- **A check that has never been red is a decoration.** Each check the gate runs is proven able to fail, on a planted defect, every run; a warning is proven the same way, by a plant that must produce it and an excused line that must not

## Evaluation

One evaluation pass, when a plan includes one. After that the skill is judged by use: the user watches it load and act, and a second with-and-without comparison, a regrade or a new viewer spends tokens on a question the first pass and daily use have answered. When an evaluation shows a weak assertion, that is reported and the work stops there
