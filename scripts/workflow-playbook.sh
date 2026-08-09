#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: when a Bash command or an edited path signals
# entry into a workflow-shaped activity (a DB migration, a release), surface
# the project's vetted playbook for it — even mid-task under a pinned task.
# Logic lives in `commitmind hook workflow-playbook` (Go subcommand); the
# daemon dedups per (task, kind) and only answers when a relevant playbook is
# synced locally. Fail-open; never blocks.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook workflow-playbook
