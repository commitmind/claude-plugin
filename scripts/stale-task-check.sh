#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind Stop hook: sweeps EVERY non-terminal task in this project
# (discovery / design / implementation) and nudges when one has gone
# untouched long enough to be considered forgotten — the "agent created
# a task, moved it to design, then forgot it" failure mode. This is
# distinct from the session-reground / stuck-design nudges, which only
# look at the task PINNED to this session: a long session can be busy on
# other work while a parked task quietly rots with no pin. Logic lives in
# `commitmind hook stale-task-check` (Go subcommand): it asks the daemon
# (scoped by session_id + cwd) for the stalest task past the threshold
# and emits a systemMessage naming it, re-armed per-task so it doesn't
# nag. Always exits 0 (informational, never blocks).
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook stale-task-check
