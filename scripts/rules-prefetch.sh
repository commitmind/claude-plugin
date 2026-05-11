#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: when Claude Code is about to call
# Read / Edit / Write / MultiEdit on a project file, fetch the rules
# that apply to that path and emit them as system-reminder context
# so the agent sees the rules block BEFORE making the call. Logic
# lives in `commitmind hook rules-prefetch` (Go subcommand). Per-
# (session_id, file_path) dedup is server-side state under TMPDIR.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook rules-prefetch
