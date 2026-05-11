#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: on the first Edit / Write / MultiEdit
# of a daemon process, surface a system-reminder pointing the agent
# at `list_playbooks`. Logic lives in `commitmind hook
# surface-playbook` (Go subcommand). The atomic check-and-set is
# server-side (POST /v1/hooks/surface-playbook-mark); subsequent
# calls silent-allow.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook surface-playbook
