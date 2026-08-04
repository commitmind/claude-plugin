#!/usr/bin/env bash
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
