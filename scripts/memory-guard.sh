#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: when a Write/Edit/MultiEdit targets a LOCAL
# memory file (Claude Code's ~/.claude/**/memory/**, or a project MEMORY.md;
# CLAUDE.md excluded), warn the agent to persist to CommitMind's memory tools
# instead. Logic lives in `commitmind hook memory-guard` (Go subcommand). This
# launcher pipes the Claude Code stdin envelope to the subcommand and forwards
# its output. Advisory only — the subcommand always exits 0 (never blocks).
#
# Silent-allow when the commitmind binary isn't on PATH — matches the other
# routing hooks' silent-failure semantics, so a user without commitmind on
# PATH sees no errors (just no memory-routing nudge).

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook memory-guard
