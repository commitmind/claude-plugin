#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: when a Write/Edit/MultiEdit targets a LOCAL
# memory file (Claude Code's ~/.claude/**/memory/**, or a project MEMORY.md;
# CLAUDE.md excluded), warn the agent to persist to CommitMind's memory tools
# instead. Logic lives in `commitmind hook memory-guard` (Go subcommand). This
# launcher pipes the Claude Code stdin envelope to the subcommand and forwards
# its output. Advisory only — the subcommand always exits 0 (never blocks).
#
# Silent-allow when the commitmind binary isn't on PATH — matches the other
# routing hooks' silent-failure semantics, so a user without commitmind on
# PATH sees no errors (just no memory-routing nudge).

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook memory-guard
