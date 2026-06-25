#!/usr/bin/env bash
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
