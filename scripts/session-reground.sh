#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind Stop hook: after a session has run long enough, nudges the
# agent to re-verify load-bearing assumptions (xref / search_memory /
# re-read) before trusting a possibly-stale mental model — and to
# /compact if context feels heavy. The deeper long-session failure is
# overconfidence in an outdated model, not raw token count, so the nudge
# pushes re-grounding first and compaction second. Logic lives in
# `commitmind hook session-reground` (Go subcommand): it reports the
# turn to the daemon (keyed by session_id) and emits a systemMessage
# only once the re-ground threshold is crossed, re-arming periodically.
# Always exits 0 (informational, never blocks).
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook session-reground
