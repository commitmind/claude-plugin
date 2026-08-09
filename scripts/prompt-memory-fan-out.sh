#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind UserPromptSubmit hook: when the user submits a non-
# continuation prompt, fan out search_memory + recall_learning +
# list_playbooks against the prompt and emit a system-reminder with
# the top hits. Logic lives in `commitmind hook prompt-memory-fan-out`
# (Go subcommand). Per-(session, prompt-hash) dedup; per-session
# injected-item dedup across prompts; persists active-task path
# allowlist for the routing-enforce hook to read on each Read
# PreToolUse.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook prompt-memory-fan-out
