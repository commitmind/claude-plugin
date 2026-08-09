#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse worktree gate: at the FIRST Edit/Write/MultiEdit of a
# session where another LIVE agent already shares this git checkout, blocks ONCE
# (exit 2) recommending `commitmind worktree new` — the risk-moment complement to
# the SessionStart peers nudge (session-peers-check.sh), which is one-shot and
# misses peers who join after a session starts. Re-issuing the edit proceeds
# (the gate fires once per session). Logic lives in
# `commitmind hook first-edit-peers-check`.
#
# Silent-allow when the commitmind binary isn't on PATH — the gate must never
# block on missing tooling.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook first-edit-peers-check
