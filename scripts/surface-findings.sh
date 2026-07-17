#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind UserPromptSubmit hook: routes ASYNC AI security findings back to the
# agent. The background reconciler runs the generate→refute pass after a commit
# and writes findings to the local ledger; this hook asks the daemon for any that
# have never been shown to this session and injects them as a <system-reminder>,
# so the agent can fix them while still in context instead of only a human seeing
# them in the dashboard. Logic lives in `commitmind hook surface-findings`.
#
# The daemon stamps returned findings "surfaced" in the same call, so each
# appears exactly once. Fail-open: not a CommitMind repo, daemon unreachable, or
# an empty queue emits nothing. Silent-allow when the commitmind binary isn't on
# PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook surface-findings
