#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: blocks marking a task done
# (mcp__mind__task_complete, or mcp__mind__task_advance with
# to_phase=done) while files edited under that task still have
# uncommitted changes. Logic lives in `commitmind hook done-gate` (Go
# subcommand): it asks the daemon which files the active task touched,
# intersects them with `git status --porcelain`, and exits 2 to block
# when any attributed file is dirty. Fails open on any infra error;
# unpushed commits never block. Override with COMMITMIND_DONE_GATE=off.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook done-gate
