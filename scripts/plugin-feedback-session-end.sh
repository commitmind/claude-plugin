#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
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
