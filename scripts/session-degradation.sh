#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind Stop hook: detect a degrading session (a rework loop — the
# same problem keeps coming back) and nudge the user to /clear with a
# resume handoff. Cheap-gated on the daemon's corrective-prompt run;
# only then reads the recent transcript and runs an isolated `claude -p`
# judge. Logic lives in `commitmind hook session-degradation` (Go
# subcommand). Always exits 0 — conservative, never blocks. (task 52585a8c)
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook session-degradation
