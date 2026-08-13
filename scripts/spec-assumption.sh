#!/usr/bin/env bash

# CommitMind's own local review agent runs `claude -p` with the REPO as cwd, so
# it inherits these hooks. Their output is injected into that agent's context and
# the model answers the hook instead of the review prompt (task 425ecbb).
if [ -n "${COMMITMIND_REVIEW_AGENT:-}" ]; then exit 0; fi
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind UserPromptSubmit hook: surfaces the behavioural assumption the
# active task's linked spec rests on, once, so it can be tested before the
# design is built on. The daemon articulates it on YOUR OWN coding agent when the
# task enters implementation, then stashes it; this hook pops it on the next
# prompt. Logic lives in `commitmind hook spec-assumption`.
#
# Advisory only — never gates. Fail-open: not a CommitMind repo, daemon
# unreachable, or nothing pending emits nothing. Silent-allow when the
# commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook spec-assumption
