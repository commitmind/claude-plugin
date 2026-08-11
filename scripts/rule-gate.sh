#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Without this exit the agent would be gated by the
# project's own rules mid-review (task 425ecbb). `if` rather than `&&` so a
# failed test can't trip `set -e`.
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse hook: BLOCK a tool call that a human-approved project
# rule forbids. Registered with matcher ".*" so it sees EVERY tool — that is the
# point. Before this, every gate was hard-coded per tool (anchor-edit for
# Edit/Write, done-gate for task transitions), so a rule about any tool nobody
# had hard-coded had no enforcement point and was advisory in practice.
#
# Logic lives in `commitmind hook rule-gate` (Go subcommand). This launcher pipes
# the Claude Code stdin envelope to it and forwards its exit code:
#   exit 0 = allow (the overwhelmingly common path)
#   exit 2 = BLOCK, with the rule's own text on stderr
#
# Unlike the advisory hooks, this one CAN block. Escape hatches, in order of
# preference: fix the rule, or set COMMITMIND_RULE_GATE=off for the session.
#
# Silent-allow when the commitmind binary isn't on PATH — matches every other
# CommitMind hook. This is a deliberate asymmetry with the gate's own fail-closed
# behaviour: no binary means CommitMind is not installed for this shell at all,
# which is not the same as "installed but unable to read the rules", and blocking
# every tool call on a PATH problem would be indefensible.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook rule-gate
