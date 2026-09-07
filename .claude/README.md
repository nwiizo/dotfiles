# Claude Code Entry Points

Claude Code reads project subagents, skills, and rules from `.claude/`.
This repository keeps the source files in `.agents/` and exposes them here as
symlinks:

| Path | Source |
|---|---|
| `agents/` | `../.agents/agents/` |
| `rules/` | `../.agents/rules/` |
| `skills/` | `../.agents/skills/` |

`plugins/` contains local Claude-only integrations and their marketplace
manifest. Edit these files here, then update the installed plugin with the CLI.

Use `.agents/` for edits to the symlinked assets. These links expose them as
project-scoped Claude Code configuration while `scripts/link.sh` also links
them into `~/.claude`. Keep `CLAUDE.md` thin; durable shared guidance belongs
in `AGENTS.md`.

## Personal configuration

Reviewed on 2026-09-06 against Claude Code **2.1.261**, the current
[release](https://github.com/anthropics/claude-code/releases/tag/v2.1.261).
The native installation manages updates on the `latest` channel.

`~/.claude/settings.json` is a local file, not a symlink or a checked-in
template. It contains model, permission, sandbox, hook, and plugin preferences.
`~/.claude.json` is application state, including authentication and MCP
registrations; do not copy it into this repository. Project-specific settings
belong in the project's `.claude/settings.json` or `.claude/settings.local.json`.
See the [settings scopes and precedence](https://code.claude.com/docs/en/settings).

The current choices are:

| Area | Choice and maintenance rule |
|---|---|
| Model | Keep `fable[1m]` and `effortLevel: "xhigh"`; use `/effort` for a task-specific change. Fixed thinking-budget overrides are unnecessary for Fable. |
| Permissions | Keep `defaultMode: "auto"` and the existing deny rules. `c` remains the explicitly approved bypass shortcut; `cc` uses configured permissions. |
| Sandbox | Keep filesystem/network isolation enabled and allow commands that stay inside it. Permission rules supplement isolation; matching a few shell command strings cannot prohibit every equivalent command. |
| Questions | Keep the existing five-minute question auto-continue setting. |
| Interface | Keep fullscreen rendering, automatic theme selection, and the existing attribution preferences. |
| Notifications | Keep the tab bell plus the desktop notification hook described in the [Ghostty guide](../ghostty/README.md#ai-notifications). |
| Instructions | Keep the short global `CLAUDE.md`, path-scoped language rules, and skills loaded when needed. `@RTK.md` is an intentional startup import. |

The review removed these global environment overrides:

| Removed setting | Reason |
|---|---|
| `CARGO_INCREMENTAL=1`, `GO111MODULE=on` | Let project configuration and the installed toolchain choose build behavior. |
| `NODE_ENV=development` | Avoid forcing development mode on tests, package scripts, and production builds. |
| `RUSTFLAGS=-C target-cpu=native` | Avoid overriding project compiler flags and making every build target this machine's CPU. |
| `UV_SYSTEM_PYTHON=1` | Let uv use a project virtual environment instead of globally selecting system Python. |
| `SHELL=/opt/homebrew/bin/fish` | Inherit the user's shell environment. Claude's Bash tool supports Bash/Zsh and selects one automatically when the login shell is Fish. |

The stale `feedbackSurveyState` copy was also removed from `settings.json`;
Claude manages that state in `~/.claude.json`. Existing telemetry and company
usage-analytics settings remain in place.

Removing an environment variable from settings takes effect in a **new Claude
process**. A running process retains the old value. See the
[environment variable reference](https://code.claude.com/docs/en/env-vars),
[uv's system-Python option](https://docs.astral.sh/uv/reference/environment/#uv_system_python),
and [Rust's target CPU option](https://doc.rust-lang.org/rustc/codegen-options/index.html#target-cpu).

## Plugins, LSP, and hooks

The 18 enabled plugins are installed. Keep their cached files under
`~/.claude/plugins` under the plugin manager's control. LSP plugins configure a
server but [do not install its executable](https://code.claude.com/docs/en/plugins-reference#lsp-servers).

| Enabled LSP plugin | Required executable |
|---|---|
| `gopls-lsp` | `gopls` |
| `lua-lsp` | `lua-language-server` |
| `pyright-lsp` | `pyright-langserver` |
| `rust-analyzer-lsp` | `rust-analyzer` |
| `home-typescript-lsp@nwiizo-local` | Homebrew TypeScript 7's `tsc --lsp --stdio` |

Lua and TypeScript are explicit Homebrew dependencies in `Brewfile`. TypeScript
uses `link: false` and the plugin calls `/opt/homebrew/opt/typescript/bin/tsc`
directly, preserving the existing npm-managed `tsc` command. Neovim's Mason
directory is not assumed to be on Claude's PATH.

The official `typescript-lsp` plugin is installed but disabled. Its
`typescript-language-server` expects `tsserver.js`, which TypeScript 7 no longer
ships. The local plugin uses the native LSP instead; it contains only a server
configuration, with no hooks, MCP servers, skills, or custom executable. This
selects TypeScript 7 language-service behavior even in projects using an older
compiler. Keep project build/type-check commands tied to their own dependencies.
See [TypeScript's migration](https://github.com/microsoft/typescript-go#typescript-7)
and the [legacy server's compatibility issue](https://github.com/microsoft/TypeScript/issues/64094).

To install this integration on another Apple Silicon Mac after installing the
Brewfile dependencies:

```sh
rtk proxy claude plugin marketplace add "$PWD/.claude/plugins" --scope user
rtk proxy claude plugin install home-typescript-lsp@nwiizo-local --scope user
rtk proxy claude plugin disable typescript-lsp@claude-plugins-official --scope user
```

The last command applies only if the legacy plugin is already installed. For
updates, increment the local plugin's version, run
`claude plugin marketplace update nwiizo-local`, then
`claude plugin update home-typescript-lsp@nwiizo-local`. Start a new session to
load changed LSP definitions. Keep only one TypeScript LSP plugin enabled;
Claude uses the first registered server for an extension.

`PreToolUse` runs `rtk hook claude`. The hook returns `updatedInput` without an
`allow` permission decision, leaving permission checks to Claude Code. Keep
Herdr's session hook managed by Herdr and company analytics managed by its
plugin. The Codex plugin's stop-review hook checks its own opt-in setting before
starting a review; its presence alone does not mean every turn runs a review.

Claude Code also supports native Ghostty notifications with
`preferredNotifChannel: "auto"`. The existing hook is retained for the combined
tab-bell and banner behavior; switching to native desktop notifications would
also require removing this hook to avoid duplicate banners. See the
[terminal notification reference](https://code.claude.com/docs/en/terminal-config#get-a-terminal-bell-or-notification).

## Research and verification

The [official best practices](https://code.claude.com/docs/en/best-practices)
and [Trail of Bits' configuration](https://github.com/trailofbits/claude-code-config)
support concise startup instructions, scoped rules, and explicit verification.
The [community reference](https://github.com/shanraisshan/claude-code-best-practice)
is useful for discovering features; verify their current behavior against the
CLI and official documentation. These are different workflows, not one agreed
set of optimal settings. Experimental agent teams, blanket permission grants,
privacy switches, and extra MCP servers are not prerequisites for this setup.

After changing configuration, run:

```sh
rtk proxy claude doctor
rtk proxy claude plugin list
rtk proxy claude plugin validate .claude/plugins
rtk proxy jq empty ~/.claude/settings.json
rtk proxy brew bundle check --file Brewfile --no-upgrade
rtk proxy bash scripts/audit-agent-config.sh
rtk git diff --check
```

Inside an interactive session, `/status` shows loaded settings sources,
`/context` shows context usage, `/hooks` lists hooks, and `/plugin` exposes
component errors. `csafe` starts with personal customizations disabled while
retaining normal authentication and permissions. `cbare` also skips OAuth and
keychain authentication; it is for API-key or `apiKeyHelper` workflows, not a
general replacement for `csafe`.

Verification on 2026-09-06: native `doctor`, plugin/marketplace validation,
settings JSON parsing, Brewfile dependency checks, agent asset audit, and
notification-hook fixtures passed. Lua, Go, Python, and Rust completed LSP
initialization; the installed TypeScript plugin completed initialization,
hover, definition, and reference requests against a temporary TypeScript file.
No model-generated task or desktop notification delivery was exercised.

TypeScript 7.0.2 acknowledged `shutdown` but exited with status 1 after `exit`;
the native server also emits `context canceled` on this termination path.
This is a server-side limitation, also visible in
[upstream logs](https://github.com/microsoft/typescript-go/issues/3026), not a
successful clean-exit check. The language-service requests above completed
before shutdown.

Keep MCP authentication and connection status local. Use `/mcp` to check the
connector needed for the current task; authenticate it or start its local
service when required. Do not publish account-specific health-check results.
