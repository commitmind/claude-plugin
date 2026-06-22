#!/usr/bin/env bash
# CommitMind Stop hook (Lever 2, spec 6e7a913a): nudge when the just-finished
# turn signals the work is done/shipped/ready in prose while the active task is
# still in `implementation` — the turn-end "done, committed" claim the
# git-commit + phase-reminder nudges don't see. Logic lives in `commitmind hook
# done-claim-check` (Go subcommand): it reads the Stop envelope from stdin,
# inspects the latest assistant turn, queries the daemon's
# /v1/hooks/active-task-check for the pinned task's phase, and emits a
# {"systemMessage":...} at most once per (session, claim). Always exits 0 —
# informational, never blocks.
#
# Silent-allow when the commitmind binary isn't on PATH. `exec` preserves stdin
# so the subcommand sees the hook envelope.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook done-claim-check
