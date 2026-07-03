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

# --- Gate 1: cheap skip for non-repo dirs ($HOME, etc.). ---
# We DON'T gate on a project .mcp.json anymore. The Claude Code plugin
# registers the MCP servers from its OWN bundled config and writes no
# project-level .mcp.json, so connected repos under the plugin model
# frequently have none — the old grep silently skipped them and the
# announce never fired ("Claude isn't aware of CommitMind"). The
# authoritative signal is whether the repo has an agent token, which
# `commitmind prime` checks internally and exits silently (0) when
# absent. So here we only do a cheap git-repo guard to avoid spawning
# the binary in non-git dirs, and let `prime` self-gate on the token.
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
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
#     still loads.
#
#     --skip-on-compact: this unmatched SessionStart hook fires on EVERY
#     source including `compact`, but a separate compact-matched hook
#     (auto-post-compact.sh) already emits a focused reprime there. On a
#     compaction, running the full prime too just buries that reprime's
#     FIRST-ACTION tool-preload in a wall of sections competing with Claude's
#     "resume directly" handoff. `prime` reads the SessionStart envelope on
#     stdin (which this hook receives) and emits nothing when source=compact,
#     deferring to auto-post-compact.sh. Fail-open on non-compact / no stdin.
#     Spec 4c6b0351. ---
timeout 12 "$binary" prime --hook-envelope --skip-on-compact 2>/dev/null || true
