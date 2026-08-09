#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: when Claude Code is about to Write a
# brand-new source file, check whether the symbol(s) it introduces
# already exist elsewhere in the project index and, if so, surface a
# system-reminder pointing at the existing definition so the agent
# reuses it instead of recreating it. Soft nudge — never blocks the
# Write. Logic lives in `commitmind hook duplicate-guard` (Go
# subcommand). Per-(session_id, file_path) dedup; silent on overwrites,
# non-source files, and when nothing collides.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook duplicate-guard
