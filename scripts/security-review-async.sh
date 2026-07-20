#!/usr/bin/env bash
# CommitMind PostToolUse(Bash) hook — async-on-commit security review (spec
# 399f6ab4). Wired in hooks.json with `if: Bash(git commit:*)` + `asyncRewake`,
# so it fires in the BACKGROUND after a real `git commit` and re-wakes the agent
# with any findings (the same mechanism the security-guidance plugin uses).
#
# It runs the context-enriched generate→refute SECURITY pass over the
# just-committed change (`commitmind review --ai-security --scope=head`), which
# catches context-mismatched-sanitizer vulns (e.g. an HTML escaper on a CSS
# sink) the deterministic engine doesn't model. The findings are advisory —
# acknowledge or address them, they never block.
#
# OPT-IN: spends AI budget per commit, so it's OFF unless ENABLE_COMMIT_SECURITY_REVIEW=1.
# The explicit `commitmind review --ai-security` is always available regardless.
#
# Two cost guards: (1) the opt-in gate above; (2) a cheap sink pre-filter — skip
# commits whose diff touches no sink-shaped construct, so trivial commits cost
# nothing. Fail-open + silent on every error (a hook must never break a commit).

set -o pipefail

# (1) opt-in gate — default OFF.
[ "${ENABLE_COMMIT_SECURITY_REVIEW:-0}" = "1" ] || exit 0

command -v commitmind >/dev/null 2>&1 || exit 0

# Need a parent commit to diff the just-landed change against.
git rev-parse --verify HEAD~1 >/dev/null 2>&1 || exit 0

diff="$(git diff HEAD~1 HEAD 2>/dev/null)" || exit 0
[ -n "$diff" ] || exit 0

# (2) sink pre-filter — only spend tokens when the committed diff touches a
# sink-shaped construct (command/SQL/HTML/CSS/JS/path/deserialize/template/
# redirect). Broad on purpose: a missed pre-filter just means no AI review on
# that commit, never a blocked commit. Matches added lines only (leading '+').
sinks='exec|eval|system|popen|subprocess|ProcessBuilder|Runtime\.|innerHTML|dangerouslySetInnerHTML|document\.write|<style|<script|new Function|render|template|\$\{|query|Query\(|execute|prepareStatement|unserialize|pickle|yaml\.load|marshal|deserialize|redirect|sendRedirect|location\.|open\(|readFile|writeFile|os\.path|filepath\.|new File'
printf '%s\n' "$diff" | grep -E '^\+' | grep -qiE "$sinks" || exit 0

# Run the security pass on the just-committed change. Stdout becomes the
# asyncRewake notification body. --format=text keeps it human/agent-readable.
out="$(commitmind review --ai-security --scope=head --format=text 2>/dev/null)" || exit 0
# Nothing surfaced → no rewake (don't wake the agent on a clean commit).
[ -n "$out" ] || exit 0
printf '%s\n' "$out"

# Adoption nudge: turn an FP judgment into RECORDED, measurable signal instead of
# a silent move-on. Without this, dismissed findings vanish and the AI-review
# precision loop stays blind (the gap dismiss_ai_finding closes). Phrased
# conditionally so it's harmless when every finding above is a true positive.
printf '\n---\nIf any finding above is a FALSE POSITIVE for this codebase, record it with the `dismiss_ai_finding` MCP tool (file, line, category=security, and a reason that states the fact refuting it). That feeds the AI-review precision signal and quiets the shape on future runs — do NOT silently ignore it. Address the real findings.\n'
