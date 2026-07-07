#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: when Claude Code is about to Write a
# brand-new source file, check whether the symbol(s) it introduces
# already exist elsewhere in the project index and, if so, surface a
# system-reminder pointing at the existing definition so the agent
# reuses it instead of recreating it. Soft nudge — never blocks the
# Write. Logic lives in `commitmind hook duplicate-guard` (Go
# subcommand). Per-(session_id, file_path) dedup; silent on overwrites,
# non-source files, and when nothing collides.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook duplicate-guard
