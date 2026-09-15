# Pitfalls

Reproducible traps in a tool, a platform or the maintenance process, each with the misleading observation and the safe way through

## macOS collates Cyrillic strings as equal, and `uniq` compares in that collation

**Scope:** every `sort | uniq -d` over text that may hold non-ASCII, in `check-skill.sh` the trigger-duplicate check; the `macos` workflow, which runs the behaviour half under the tools macOS ships

**Reproduction:** the description of this very skill, whose Russian triggers include `скилл`, `триггеры`, `новый скилл` and `чужой скилл`, run through `tr ',' '\n' | sort | uniq -d` on a macOS runner (macOS 26, arm64, bash 3.2.57). The output names `скилл` and `новый скилл` as listed twice; on Linux the same pipeline prints nothing

**Misleading observation:** the finding reads as a real duplicate at a plausible place, and the local run, on GNU tools, cannot reproduce it. The mechanism is the locale: in a UTF-8 locale macOS's collation gives non-ASCII characters no weight, so `скилл` collates equal to `триггеры` and every two-word Cyrillic trigger to every other, and BSD `uniq` decides equality by that collation rather than by bytes

**Safe way through:** compare bytes. `LC_ALL=C sort | LC_ALL=C uniq -d` on any pipeline whose lines can be non-ASCII, the same way `tr` in this repository already runs under `LC_ALL=C`. The gate proves it only where the trap exists, on the macOS runner; a green run on Linux says nothing about it
