#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind multi-event hook (UserPromptSubmit + PreToolUse +
# PostToolUse): closes the "user reports a bug mid-implementation →
# agent goes straight to Edit without anchoring" gap. Logic lives
# in `commitmind hook anchor-user-work` (Go subcommand). Maintains
# a per-session marker + fired pair under TMPDIR; UserPromptSubmit
# sets/clears, PreToolUse coaches once per cycle, PostToolUse on
# task_todo_add clears the cycle.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook anchor-user-work
