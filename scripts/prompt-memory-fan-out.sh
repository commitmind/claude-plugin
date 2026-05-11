#!/usr/bin/env bash
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
