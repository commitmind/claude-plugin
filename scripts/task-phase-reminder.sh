#!/usr/bin/env bash
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
