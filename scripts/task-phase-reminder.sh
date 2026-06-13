#!/usr/bin/env bash
# Coaching nudge for CommitMind-linked projects: when an Edit / Write /
# MultiEdit lands, surface a one-line reminder that the active CommitMind
# task should be in `implementation`, not `discovery`, before edits begin.
#
# Gating is intentionally conservative:
#   1. Only fires when cwd is a CommitMind-enabled repo, detected by
#      `commitmind hook in-project` (shared Go gate: project MCP config
#      OR an agent token — the latter is the only signal present under
#      the Claude Code plugin, which writes no project .mcp.json).
#   2. Debounced per-repo to once every 5 minutes via $TMPDIR state.
#
# This is a soft nudge, not state-aware — the script does NOT query the
# server for the actual phase (no shell session ID = no active-task lookup).
# The agent still owns the decision; the hook just prevents "I forgot the
# task lifecycle existed" from being a silent failure mode.

set -e

# --- Gate 1: are we in a CommitMind-enabled repo? ---
# Silent-skip when commitmind isn't on PATH (matches the other hooks'
# fail-open contract) or when the shared Go gate says this isn't a
# CommitMind repo.
if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
if ! commitmind hook in-project >/dev/null 2>&1; then
    exit 0
fi

# --- Gate 2: debounce. Once per repo per 5 minutes. ---
state_dir="${TMPDIR:-/tmp}/commitmind-phase-reminder"
mkdir -p "$state_dir"
# Sanitize cwd to a safe filename — strip leading slash, replace remaining
# separators. Avoids collisions across repos with similar tails.
key=$(pwd | sed 's|^/||' | tr '/' '_')
state_file="$state_dir/$key.last"
now=$(date +%s)
if [[ -f "$state_file" ]]; then
    last=$(cat "$state_file" 2>/dev/null || echo 0)
    if (( now - last < 300 )); then
        exit 0
    fi
fi
echo "$now" > "$state_file"

# --- Emit. Stdout becomes system-reminder context for the next turn. ---
cat <<'REMINDER'
[CommitMind] Phase check: you just edited a file in a CommitMind-linked project. If your active task is still in `discovery`, advance it to `implementation` via the task_advance MCP tool BEFORE the next edit. The dashboard reflects what you call, not what you do. — coaching layer C
REMINDER
