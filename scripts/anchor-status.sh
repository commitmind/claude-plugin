#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind UserPromptSubmit hook: keeps the session's task-anchor state
# salient every turn. Logic lives in `commitmind hook anchor-status` (Go
# subcommand): it asks the daemon whether a task is pinned to this session and
#   - when NONE is pinned, nudges every turn toward task_set_active / task_create
#     (un-anchored work is the drift this exists to catch);
#   - when a task IS pinned, confirms once and then stays silent until the pin
#     changes (per-session marker), so a steady pin never nags.
#
# Fail-open: not a CommitMind repo, daemon unreachable, or a bad envelope emits
# nothing. Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook anchor-status
