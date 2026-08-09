#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: when Claude Code is about to Read a project
# source file, accumulate the distinct files read this session. Once they
# cluster (>=2 distinct) on a subsystem that has a capability doc — resolved
# by vector similarity over the locally-mirrored docs — push that doc's
# summary + body as system-reminder context, once per doc per session, so an
# agent mapping a subsystem builds on the as-built doc instead of re-deriving
# it from the tree. Logic lives in `commitmind hook read-cluster-capdoc` (Go
# subcommand). Fail-open: no synced embeddings / embed unavailable / no repo
# => no push; never blocks a Read.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook read-cluster-capdoc
