#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: when Claude Code is about to call
# Edit / Write / MultiEdit on a project file, fetch the explain
# envelope (decisions / observations / commit summaries) for that
# file and surface it as system-reminder context (parent agent: soft
# hint, subagent: hard block). Logic lives in `commitmind hook
# explain-prefetch` (Go subcommand). Per-(session_id, file_path)
# dedup; silent on files with no curated context.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook explain-prefetch
