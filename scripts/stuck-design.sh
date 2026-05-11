#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind Stop hook: warns when the active task accumulated >= N
# Edit/Write calls without advancing phase. Logic lives in
# `commitmind hook stuck-design` (Go subcommand). This launcher pipes
# the Claude Code stdin envelope to the subcommand and forwards its
# stdout (a {"systemMessage":"..."} JSON envelope when the daemon
# decides to warn) and exit code (always 0 — Stop-hook warnings are
# informational, not blocking).
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook stuck-design
