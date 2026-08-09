#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
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
