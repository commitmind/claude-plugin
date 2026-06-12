# CommitMind for Claude Code

The CommitMind Claude Code plugin — deterministic memory, code-intel, and task workflows via skills + hooks.

## Requirements

- The `commitmind` CLI installed and on `PATH`.
- A CommitMind subscription, with the current repo authenticated via `commitmind init`.

The plugin itself is a free convenience layer. The subscription gate fires server-side via the existing CLI auth path.

## What's bundled

- **MCP servers** — `mind` (memory + tasks) and `mind-code` (xref + code-intel), wired via `.mcp.json` to the locally-installed CLI binary.
- **Skills** — advisory routing for memory, code, and playbook flows. Lazy-loaded by description match.
- **Hooks** — deterministic gates that fire before tool execution: anchor-distinct-concerns on Edit/Write, commit-before-advance on `task_advance`, memory-routing redirects for `git log` / `grep`-on-identifier patterns, lean SessionStart prime.

## Reliability scope

Hooks fire **only on local Claude Code CLI**. Cloud Claude (claude.ai/code) and web IDE extensions inherit skills + advisory only; for deterministic enforcement on those surfaces, use the `mind` agent (bundled with the same subscription).

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
