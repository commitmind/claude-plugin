#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# CommitMind PostToolUse hook: after an Edit / Write / MultiEdit, nudge
# the agent to advance the active task to `implementation` — but ONLY
# when that task is still behind (phase discovery/design). Logic lives in
# `commitmind hook task-phase-reminder` (Go subcommand): it queries the
# daemon's /v1/hooks/active-task-check for the pinned task's phase and
# stays silent once the task is in implementation/review, so the reminder
# stops being noise. Per-cwd 5-minute debounce.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook task-phase-reminder
