# Deviations

Intentional departures from the obvious route, with the trade each one makes and the condition under which it is worth revisiting

## Warnings go to stdout, findings to stderr

**Scope:** `warn()` in `check-skill.sh`, and every warning line it prints; the `--strict` flag, which is the only path by which a warning reaches stderr

**Consequence:** a warning printed to stderr, as human text ordinarily is, turns a consumer's proof red for the wrong reason. The gates of the family plant a defect in a copy of their repository, run `check-skill.sh` on it and read the first stderr line matching `check-skill:` as the reason the copy failed; the `catches()` helper in the [tests](https://github.com/rokokol/tests-skill) skill's gate is one such reader. A warning on the copy's unrelated line would be read as that reason, and a planted defect would be reported as caught by the wrong check

**Mechanism:** an error is the first finding and exits 1, so stderr carries exactly one `check-skill:` line per failed run and a reader may take the first. Warnings are many, do not change the exit code and appear on passing runs too; on stderr they would precede the finding. Under `GITHUB_ACTIONS` each warning is also emitted as a `::warning file=…,line=…::` annotation, which the runner renders regardless of the stream

**Exit:** revisit if every consumer gate stops reading stderr for the reason a copy failed, which is the shape the family's falsification has; until then the split stands
