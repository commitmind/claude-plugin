#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse + PostToolUse hook: route grep / Read on indexed
# code to the indexed CommitMind tools (xref + memory). Logic lives in
# `commitmind hook routing-enforce` (Go subcommand). This launcher
# pipes the Claude Code stdin envelope to the subcommand and forwards
# its exit code (0 = silent allow / hint, 2 = block).
#
# Silent-allow when the commitmind binary isn't on PATH — matches the
# previous python3-based hook's silent-failure semantics, so a user
# without commitmind on PATH sees no errors (just no routing
# protection).

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook routing-enforce
