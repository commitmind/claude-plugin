#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PostToolUse hook: runs the full review pipeline on the
# file edited by Edit / Write / MultiEdit (type-aware, linters, project
# rules, security — not just native kind:code rules) and surfaces any
# gating findings as a system-reminder, so the agent fixes them before
# they block `mind commit`. Logic lives in `commitmind hook check-edit`
# (Go subcommand). Always exits 0 — the edit already landed, blocking is
# moot.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook check-edit
