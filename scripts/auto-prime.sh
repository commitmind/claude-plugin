#!/usr/bin/env bash
# Auto-prime CommitMind context at session start. When the cwd is a
# CommitMind-linked repo, runs `commitmind prime` and emits the markdown
# to stdout so Claude Code surfaces it as session-start context. The
# agent reads the conventions block + recent activity at the very top of
# every session — no manual `prime_session` call required.
#
# Failure modes are intentionally silent:
#   - Not in a git repo / not a CommitMind project → silent exit 0.
#   - `commitmind` binary not on PATH → silent exit 0 with a hint.
#   - API down / timeout → `commitmind prime` already prints a fallback
#     conventions block and exits 0; we just pass that through.
#
# The whole point of this hook is to make the right thing happen
# automatically; it must NEVER block or noise up a session that
# happens to be outside a CommitMind project.

set -e

# --- Gate 1: only fire in CommitMind-linked projects. ---
# Same detector as commitmind-task-phase-reminder.sh: presence of a
# `commitmind` entry in either .mcp.json (Claude Code project config)
# or .cursor/mcp.json (Cursor project config).
has_cm=0
for f in .mcp.json .cursor/mcp.json; do
    if [[ -f "$f" ]] && grep -qE '"(commitmind|mind)"' "$f" 2>/dev/null; then
        has_cm=1
        break
    fi
done
if (( ! has_cm )); then
    exit 0
fi

# --- Gate 2: locate the commitmind binary. ---
binary=""
if command -v commitmind >/dev/null 2>&1; then
    binary="$(command -v commitmind)"
fi
if [[ -z "$binary" ]]; then
    # Don't nag on every session start — silent exit. If the user
    # actually wants the auto-prime they'll notice the missing context
    # eventually and either symlink the binary or rebuild it.
    exit 0
fi

# --- Run with a tight timeout so a backend hiccup doesn't slow the
#     session start. The CLI has its own 10s timeout; we cap at 12s
#     here as a belt + suspenders.
#
#     --hook-envelope wraps the markdown in Claude Code's SessionStart
#     hookSpecificOutput JSON envelope and emits a one-line
#     systemMessage summary that Claude Code is supposed to render to
#     the user pre-prompt. As of 2.1.x, plain-stdout hook output goes
#     silently into additionalContext (no visible chat artifact); the
#     systemMessage is the only documented mechanism that's supposed to
#     surface visibly. It has known rendering bugs (issue #15344 etc.)
#     so this isn't guaranteed to render, but when it works the user
#     gets the visible "CommitMind Ready" line above their prompt,
#     and when it doesn't we lose nothing — the additional context
#     still loads. ---
timeout 12 "$binary" prime --hook-envelope 2>/dev/null || true
