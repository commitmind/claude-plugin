#!/usr/bin/env bash
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
