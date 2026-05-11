#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind UserPromptSubmit hook: when the user's prompt contains
# history-shaped framing ("we built X", "what changed", "why does Y
# exist"), emit a routing reminder pointing the agent at search_memory
# + recent_activity BEFORE it reads code or asserts state. Logic
# lives in `commitmind hook history-shaped-prompt` (Go subcommand).
# Per-session dedup; continuation-prompt skip.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook history-shaped-prompt
