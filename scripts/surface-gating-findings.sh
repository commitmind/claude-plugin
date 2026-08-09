#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# CommitMind PreToolUse hook: re-surface the findings that BLOCKED the last
# `mind commit`, which stderr may have truncated before the agent read them
# (spec 96e2d01c).
#
# PreToolUse, not PostToolUse: the gate exits non-zero, and Claude Code does not
# deliver PostToolUse context for a failing tool call (measured — theory
# 0450df6). So this fires before the agent's NEXT tool call instead.
#
# Broad matcher on purpose: after a blocked commit the agent's recovery step is
# often a Read or an Edit, not a Bash call, and a Bash-only matcher would stay
# silent through exactly that path.
#
# Logic lives in `commitmind hook surface-gating-findings` (Go subcommand): it
# reads the .git/ gating artifact, stays silent unless the set is fresh
# (head_sha == HEAD) and not yet surfaced, and stamps it so it renders once.
#
# Silent-allow when the commitmind binary isn't on PATH. `exec` preserves stdin
# so the subcommand sees the hook envelope.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook surface-gating-findings
