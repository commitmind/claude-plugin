#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook for the Agent tool: before Claude Code
# spawns a subagent, prepend a preload directive to tool_input.prompt
# so the subagent calls ToolSearch on its first action and gets the
# `xref` schema loaded. Subagents do NOT inherit the parent's
# preloaded ToolSearch state — without this nudge xref fails with
# InputValidationError on first call and the subagent falls back to
# grep / Read. Logic lives in `commitmind hook subagent-preload`
# (Go subcommand). See decisions bc80d57 + f7434cc.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook subagent-preload
