#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: when Claude Code calls create_spec, check whether
# the agent grounded the spec in code/memory this session (read a file, ran
# xref, or consulted memory). If it touched none of them, emit an advisory
# reminder to verify the spec against the code before submitting — an ungrounded
# spec, once approved, propagates invented assumptions downstream.
# Logic lives in `commitmind hook spec-grounding-check` (Go subcommand). Advisory
# only: always exits 0, never blocks. Deduped once per session. Fail-open: no
# session id / unwritable state => no nudge.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook spec-grounding-check
