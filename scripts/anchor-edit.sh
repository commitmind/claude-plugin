#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: blocks Edit / Write / MultiEdit calls
# that target real code when no task is pinned in the daemon. Logic
# lives in `commitmind hook anchor-edit` (Go subcommand). The
# ignore-list defaults (.claude/, .git/, node_modules/, dist/, etc.)
# can be overridden via .claude/settings.json under
# commitmind.anchor_edit.ignore_paths.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook anchor-edit
