#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse + PostToolUse hook: route grep / Read on indexed
# code to the indexed CommitMind tools (xref + memory). Logic lives in
# `commitmind hook routing-enforce` (Go subcommand). This launcher
# pipes the Claude Code stdin envelope to the subcommand and forwards
# its exit code (0 = silent allow / hint, 2 = block).
#
# Silent-allow when the commitmind binary isn't on PATH — matches the
# previous python3-based hook's silent-failure semantics, so a user
# without commitmind on PATH sees no errors (just no routing
# protection).

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook routing-enforce
