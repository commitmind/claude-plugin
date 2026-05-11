#!/usr/bin/env bash
# Re-prime CommitMind context after a Claude Code compaction. Fires from
# a SessionStart hook with matcher: "compact" — Claude rebuilds the
# session context after compaction, but the conversation summary tends
# to drop the behavioural contract ("tick task_todo_set_state as you
# ship"). This hook re-injects the active-task state + that contract
# reminder so the agent re-grounds before continuing work.
#
# Differs from auto-prime.sh in two ways:
#   - Runs `commitmind prime --post-compact` instead of full prime —
#     focused payload, no recent commits / observations / conventions.
#   - Tighter timeout (post-compact is lighter than full prime).
#
# Failure modes are intentionally silent: same gates as auto-prime.sh.

set -e

# --- Gate 1: only fire in CommitMind-linked projects. ---
has_cm=0
for f in .mcp.json .cursor/mcp.json; do
    if [[ -f "$f" ]] && grep -q '"commitmind"' "$f" 2>/dev/null; then
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
    exit 0
fi

# --- Run with a tight timeout. The CLI itself has a 10s deadline; we
#     wrap at 8s here since the post-compact payload is small. ---
timeout 8 "$binary" prime --post-compact 2>/dev/null || true
