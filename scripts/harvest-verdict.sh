#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PostToolUse hook on mcp__mind__log_observation: when the
# just-logged observation is verdict-shaped (a conclusion backed by
# evidence) and was not already type='harvest_candidate', nudge the
# agent to capture it as a harvest_candidate so it reaches /harvest.
# Logic lives in `commitmind hook harvest-verdict` (Go subcommand).
# Per-session dedup so one session gets at most one verdict nudge.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook harvest-verdict
