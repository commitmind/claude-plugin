#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
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
