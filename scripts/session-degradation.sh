#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
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
