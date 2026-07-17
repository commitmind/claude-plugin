#!/usr/bin/env bash
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
