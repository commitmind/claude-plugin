#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt, so the review parses
# hook chatter as its result and reports "0 of N batches reviewed" (task
# 425ecbb). `if` rather than `&&` so a failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind Stop hook: when a concurrent agent is committing to this SAME
# git checkout, proactively surface the parallel-worktree skill before the
# git race scatters this session's staged files into the other agent's
# commits. Logic lives in `commitmind hook collision-check` (Go subcommand):
# it asks the daemon for this session's active task + edited files (and a
# cheap re-arm gate), scans recent git history for foreign-task-id commits,
# and emits a systemMessage only when a collision signal fires — re-arming
# per window. Always exits 0 (informational, never blocks).
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook collision-check
