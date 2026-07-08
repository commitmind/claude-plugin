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
#     --skip-on-compact makes the full prime read the SessionStart hook
#     envelope from stdin (Claude Code pipes it there, and the binary inherits
#     this script's stdin) and emit NOTHING when source==compact. On compaction
#     the compact-matched auto-post-compact.sh reprime OWNS the payload; running
#     the full prime too would bury the reprime's FIRST-ACTION tool-preload
#     directive under the full prime's wall of sections, letting Claude Code's
#     "resume directly — do not acknowledge the summary" handoff win so the agent
#     skips the ToolSearch preload and the MCP schemas never reload — the exact
#     "forgets CommitMind after several compactions" drift (spec 4c6b0351 Slice B;
#     capability doc claude-code-plugin-sessionstart-hooks). The lean reprime
#     already carries the FIRST-ACTION preload + most-recent-task block + the
#     contract reminder, so nothing load-bearing is lost by skipping here.
#
#     Codex/OpenCode DON'T pass --skip-on-compact: they don't defer MCP tool
#     schemas (no preload to bury), so their full-prime-on-compact is harmless.
#     That host difference is why the earlier "parity with codex" reasoning
#     (which dropped this flag) was wrong for Claude specifically.
#
#     Fail-open: a non-compact source, missing envelope, or parse error falls
#     through to the normal full prime, so a real session start is never
#     suppressed. ---
# --mcp-namespace plugin: this hook only ever runs under the plugin install, so
# the full-prime ToolSearch preload emits only mcp__plugin_mind_mind__* names —
# half the both-namespaces default (task feac200).
timeout 12 "$binary" prime --hook-envelope --skip-on-compact --mcp-namespace plugin 2>/dev/null || true
