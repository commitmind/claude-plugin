#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: when Claude Code is about to call
# Edit / Write / MultiEdit on a project file, fetch the explain
# envelope (decisions / observations / commit summaries) for that
# file and surface it as system-reminder context (parent agent: soft
# hint, subagent: hard block). Logic lives in `commitmind hook
# explain-prefetch` (Go subcommand). Per-(session_id, file_path)
# dedup; silent on files with no curated context.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook explain-prefetch
