#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# CommitMind PreToolUse hook: warns (advisory, never blocks) when another live
# session is already editing the same file in this checkout, so two agents don't
# clobber each other on commit (spec 80ebc2ab, Layer B). Logic lives in
# `commitmind hook file-lease-check`. Silent-allow when the binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook file-lease-check
