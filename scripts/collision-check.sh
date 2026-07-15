#!/usr/bin/env bash
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
