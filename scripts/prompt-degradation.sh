#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind UserPromptSubmit hook: classify the submitted prompt as
# corrective/not HOOK-SIDE (the prompt text never leaves this process —
# only a boolean is sent) and feed the daemon's consecutive-corrective
# run behind the Phase-1 session-degradation gate (task 52585a8c). Logic
# lives in `commitmind hook prompt-degradation` (Go subcommand). Always
# exits 0 — never blocks the prompt.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook prompt-degradation
