#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: when Claude Code calls the mind-code xref tool,
# record that code was navigated via xref this session. This is a code-grounding
# signal parallel to reading files — it lets the spec-grounding check recognize
# an agent that grounded on the code via xref even without a Read.
# Logic lives in `commitmind hook xref-consulted` (Go subcommand). Observe-only:
# always exits 0, never blocks or delays the xref call. Fail-open: no session id
# / unwritable state => no stamp.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook xref-consulted
