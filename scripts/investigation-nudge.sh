#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PostToolUse hook for the Agent tool: when a read-only
# investigation subagent (Explore/Plan) returns, inject a NON-BLOCKING
# nudge toward explain_capability (de-dupe) then propose_capability_doc,
# so the investigation is captured as a capability doc for the next
# agent instead of re-derived. Throttled per session + per subsystem.
# Logic lives in `commitmind hook investigation-nudge` (Go subcommand);
# spec ad8387d1 (slice 7). Never blocks a tool call.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook investigation-nudge
