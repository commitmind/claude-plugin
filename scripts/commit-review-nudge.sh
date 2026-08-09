#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# CommitMind PostToolUse(Bash) hook: after a `git commit` lands while the
# active task is in `implementation`, nudge the agent to tick the slice's
# todo and advance to `review` — closing the silent-ship gap the edit-time
# task-phase-reminder leaves once a task reaches implementation (it goes
# quiet there by design). Logic lives in `commitmind hook
# commit-review-nudge` (Go subcommand): it reads the event envelope from
# stdin to confirm the command was a real git commit, queries the daemon's
# /v1/hooks/active-task-check for the pinned task's phase, and stays silent
# for any other phase / non-commit command. Per-cwd 15-minute debounce.
#
# Silent-allow when the commitmind binary isn't on PATH. `exec` preserves
# stdin so the subcommand sees the hook envelope.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook commit-review-nudge
