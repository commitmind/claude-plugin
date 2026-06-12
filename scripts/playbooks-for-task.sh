#!/usr/bin/env bash
# commitmind: managed (rebuilt by 'commitmind init --reapply'; do not edit by hand — see https://commitmind.dev/docs/coaching-hooks)
#
# CommitMind PreToolUse / PostToolUse hook: catch the agent at the
# planning moment by surfacing ranked playbooks against the task being
# created (PreToolUse on mcp__mind__task_create) or pinned
# (PostToolUse on mcp__mind__task_set_active). Logic lives in
# `commitmind hook playbooks-for-task` (Go subcommand). Per-(session,
# title) dedup inside the script means each task gets the nudge at most
# once per agent session.
#
# Closes the gap surfaced in task 1ee3576: the existing surface-playbook
# hook fires once per daemon-process at the first Edit/Write — too late,
# since the implementation plan is already locked. This hook fires at
# the moment the agent commits to the task shape (task_create) or
# resumes mid-flight (task_set_active), where reading a playbook can
# still change the approach.
#
# Silent-allow when the commitmind binary isn't on PATH.

if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook playbooks-for-task
