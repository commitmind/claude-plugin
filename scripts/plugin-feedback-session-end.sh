#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind SessionEnd hook: when the dev has opted into plugin
# telemetry, parses the Claude Code transcript JSONL on disk locally,
# computes structured counts (mind_* tool calls, routing nudge fires,
# anchor-edit blocks, should-have-used-mind anti-patterns), and POSTs
# only aggregates to the cloud API. Transcript content stays on the
# machine. Consent state lives at ~/.config/commitmind/config.json
# (opt-in at install/onboard; env override COMMITMIND_PLUGIN_FEEDBACK=off).
#
# Logic lives in `commitmind hook plugin-feedback-session-end` — this
# launcher pipes the Claude Code stdin envelope to the subcommand and
# always exits 0 (a telemetry failure must never surface to the user
# at session close).
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook plugin-feedback-session-end
