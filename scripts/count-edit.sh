#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PostToolUse hook: bumps the daemon's per-task edit
# counter on every Edit / Write / MultiEdit completion. Logic lives
# in `commitmind hook count-edit` (Go subcommand). This launcher
# pipes the Claude Code stdin envelope to the subcommand and exits 0
# regardless of outcome — count-edit is fire-and-forget and must
# never block the agent's next turn.
#
# Silent-allow when the commitmind binary isn't on PATH — matches the
# previous python3-based hook's silent-failure semantics.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook count-edit
