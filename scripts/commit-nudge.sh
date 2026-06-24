#!/usr/bin/env bash
# CommitMind PreToolUse(Bash) hook: before a raw `git commit` runs in an
# attached repo, nudge the agent to use `mind commit` instead — a SOFT,
# non-blocking suggestion (the commit still proceeds). Slice 1 of spec
# a3ac3c64. Logic lives in `commitmind hook commit-nudge` (Go subcommand): it
# reads the PreToolUse event envelope from stdin, confirms the command is a
# real `git commit` (not `mind commit`), gates on an attached CommitMind repo +
# a 15-minute per-cwd debounce, and stays silent otherwise.
#
# Silent-allow when the commitmind binary isn't on PATH. `exec` preserves
# stdin so the subcommand sees the hook envelope.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook commit-nudge
