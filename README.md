# CommitMind for Claude Code

The CommitMind Claude Code plugin — deterministic memory, code-intel, and task workflows via skills + hooks.

## Requirements

- The `commitmind` CLI installed and on `PATH`.
- A CommitMind subscription, with the current repo authenticated via `commitmind init`.

The plugin itself is a free convenience layer. The subscription gate fires server-side via the existing CLI auth path.

## What's bundled

- **MCP servers** — `mind` (memory + tasks) and `mind-code` (xref + code-intel), wired via `.mcp.json` to the locally-installed CLI binary.
- **Skills** — advisory routing for memory, code, and playbook flows. Lazy-loaded by description match.
- **Hooks** — deterministic gates that fire before tool execution: anchor-distinct-concerns on Edit/Write, commit-before-advance on `task_advance`, memory-routing redirects for `git log` / `grep`-on-identifier patterns, a soft `mind commit` nudge on raw `git commit`, lean SessionStart prime.

## Reliability scope

Hooks fire **only on local Claude Code CLI**. Cloud Claude (claude.ai/code) and web IDE extensions inherit skills + advisory only; for deterministic enforcement on those surfaces, use the `mind` agent (bundled with the same subscription).

## Committing

Use **`mind commit`** (alias for `commitmind commit`) instead of raw `git commit` — both agents and humans. It:

1. Runs the deterministic **staged review** first and fails fast — aborting before the commit if a finding meets the project's gate.
2. **Composes the message** from the staged diff via AI (default on; toggle per-project from the dashboard cog → review config, or skip with `--no-ai`).
3. Appends a single `CommitMind: task <short-id>` line linking the commit to your active task, then hands off to `git` (your normal pre-commit hook still runs).

```
mind commit                    # AI message + fail-fast review + task link
mind commit -m "your message"  # keep your own message (skips AI)
mind commit --no-review        # skip the fail-fast pass (git pre-commit hook still runs)
```

In Claude Code, a soft PreToolUse hook nudges agents toward `mind commit` when a raw `git commit` is about to run — it never blocks the commit.

## Install

```
/plugin marketplace add commitmind/claude-plugin
/plugin install mind@mind
```

For local development from the monorepo, install straight from the plugin path instead:

```
/plugin install ./apps/plugin-claude
```

## License

MIT — see [LICENSE](LICENSE).
