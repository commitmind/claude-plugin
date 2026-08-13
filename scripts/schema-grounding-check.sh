#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: when Claude Code is about to Write/Edit/MultiEdit a
# schema-shaped file (a migration, an ORM/drizzle/prisma schema, a model/entity
# definition) and the agent has grounded NOTHING this session — no file read, no
# xref, no search, no memory — soft-gate it (exit 2, steer on stderr) toward
# searching the existing surface before authoring new schema. Inventing a table
# or model blind is how wrong schema ships (task 0cd4a3c). Logic lives in
# `commitmind hook schema-grounding-check` (Go subcommand). Soft gate: exit 2
# blocks the one edit and returns control to the model, which may proceed after
# grounding or re-issuing. Deduped once per session. Fail-open: no session id /
# unwritable state / not a schema-shaped path => no gate, never blocks.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook schema-grounding-check
