#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind UserPromptSubmit hook: when the user prompt contains a
# high-precision harvest-signal phrase ("remember this", "good to
# know", etc.), nudge the agent to call log_observation with
# type='harvest_candidate', confidence=0.9. Logic lives in
# `commitmind hook harvest-finding` (Go subcommand). Per-session
# dedup so a multi-prompt conversation gets at most one nudge.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook harvest-finding
