#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: when Claude Code calls a memory-read MCP tool
# (search_memory / explain_capability / recall_learning / explain), record that
# CommitMind memory was consulted this session. This keeps the memory-first
# nudge (read-cluster-capdoc) silent for a session that did consult memory.
# Logic lives in `commitmind hook memory-consulted` (Go subcommand). Observe-only:
# always exits 0, never blocks or delays the memory call. Fail-open: no session
# id / unwritable state => no stamp.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook memory-consulted
