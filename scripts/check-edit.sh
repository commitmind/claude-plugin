#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PostToolUse hook: runs `commitmind check` on the file
# edited by Edit / Write / MultiEdit and surfaces any kind:code rule
# violations as a system-reminder. Logic lives in `commitmind hook
# check-edit` (Go subcommand). Always exits 0 — the edit already
# landed, blocking is moot.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook check-edit
