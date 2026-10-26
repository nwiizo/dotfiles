# Claude Code Entry Points

This directory exposes shared instructions and hosts local Claude-only plugins.
Edit the managed source rather than a copy under the home directory.

| Path | Managed source |
|---|---|
| `agents/` | `../.agents/agents/` |
| `rules/` | `../.agents/rules/` |
| `skills/` | `../.agents/skills/` |
| `plugins/` | Local integrations and marketplace manifest in this directory |

The root `CLAUDE.md` links to `AGENTS.md`. `scripts/link.sh` installs the shared
assets under the home directory; see the [shared configuration guide](../.agents/README.md)
for the full layout. Keep corresponding Claude and Codex roles aligned in
responsibility and read-only boundaries.

## Local settings and state

`~/.claude/settings.json` stays local. Do not duplicate its model, permissions,
plugin inventory, or hook state in this README. Keep `~/.claude.json`, credentials,
sessions, and plugin caches under the client's control. Inspect account-specific
MCP status only when needed for the task, and do not publish its output.

Edit shared guidance in `.agents/`; manage third-party plugins through the CLI.
See the [Ghostty guide](../ghostty/README.md#ai-notifications) for notification
hooks and `fish/config.fish` for the actual launch shortcuts. Changes to process
environment or startup instructions need a new session for verification.

## Local TypeScript LSP

`plugins/home-typescript-lsp/.claude-plugin/plugin.json` runs
`/opt/homebrew/opt/typescript/bin/tsc --lsp --stdio`. `Brewfile` installs TypeScript
with `link: false`, so this integration does not replace the npm-managed `tsc`
on the shell's PATH. Keep project builds and type checks on the project's own
compiler dependency; this plugin selects a separate language-service executable.

The plugin contains server configuration only. Installing it does not install
the executable. See the [plugin manifest reference](https://code.claude.com/docs/en/plugins-reference#lspservers)
when changing its fields. Keep one TypeScript LSP provider enabled to avoid
overlapping registrations.

To install on another Apple Silicon Mac, first install the Brewfile dependencies,
then run these commands from the repository root:

```sh
rtk proxy claude plugin marketplace add "$PWD/.claude/plugins" --scope user
rtk proxy claude plugin install home-typescript-lsp@nwiizo-local --scope user
```

If the legacy official TypeScript plugin is installed, disable it separately:

```sh
rtk proxy claude plugin disable typescript-lsp@claude-plugins-official --scope user
```

For an update, increment the local plugin version, then refresh the installed copy:

```sh
rtk proxy claude plugin marketplace update nwiizo-local
rtk proxy claude plugin update home-typescript-lsp@nwiizo-local
```

Start a new session after updating. Validate actual language-service requests
when changing the integration. Initialization, hover, and shutdown are separate
checks; successful initialization alone does not establish a clean exit.

## Verify changes

For managed instructions, run from the repository root:

```sh
rtk proxy ./scripts/audit-agent-config.sh
rtk git diff --check
```

For local plugin edits, also validate the manifests:

```sh
rtk proxy claude plugin validate .claude/plugins
rtk proxy claude plugin validate .claude/plugins/home-typescript-lsp
```

Run `rtk proxy ./scripts/link.sh` when installed paths change. For a local settings
change, use `rtk proxy claude doctor` and check the affected feature in a new
session. Keep verification results with the change rather than recording a
past tool version or a one-time passing result as the current state here.
