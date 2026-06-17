#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind Stop hook: once a session has run long enough (and plugin
# feedback is opted-in), asks the agent — exactly once — how its
# experience using CommitMind was, prompting a submit_session_feedback
# tool call. The qualitative counterpart to the structured session-end
# telemetry. Logic lives in `commitmind hook session-feedback` (Go
# subcommand): it reports the turn to the daemon (keyed by session_id)
# and emits a {"decision":"block","reason":...} envelope only on the
# one turn the daemon says to ask. Always exits 0.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook session-feedback
