#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind Stop hook: at turn end, inspects the just-finished assistant
# turn and nudges when it asserted an architecture/intent claim ("X was
# decided", "Y-first by design") WITHOUT calling a grounding tool
# (search_memory / explain / recall_learning / recent_activity /
# promote_decision / prime_session) that turn. Code shows WHAT is there,
# not WHY — so an ungrounded decision claim is exactly what this catches.
# Logic lives in `commitmind hook claim-check` (Go subcommand): reads the
# transcript, emits a systemMessage at most once per (session, claim).
# Always exits 0 (informational, never blocks).
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook claim-check
