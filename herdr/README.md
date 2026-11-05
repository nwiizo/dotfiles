# Herdr

Herdr is the default persistent terminal workspace manager. Ghostty provides
the terminal window; Herdr runs inside it and starts managed Fish login shells
in its panes. Claude Code and Codex remain the coding agents.

## Installation and Ownership

| Source | Role |
|---|---|
| `../Brewfile` | Homebrew `herdr` formula |
| `config.toml` | Linked to `~/.config/herdr/config.toml` |
| `../.agents/skills/herdr/` | Shared setup/control skill for Claude Code and Codex |
| `../scripts/install-herdr.sh` | Native client integrations and selected plugins |
| `../ghostty/config` | Outer terminal display, clipboard, and shell integration |

From the repository root:

```sh
rtk proxy brew bundle --file Brewfile --no-upgrade
rtk proxy ./scripts/link.sh
rtk proxy bash scripts/install-herdr.sh
```

Bootstrap runs the same setup after installing packages and linking config.
The installer refreshes integrations for installed Claude Code/Codex clients.
`--integrations-only` refreshes those hooks without installing plugins.
The native installer merges its hooks into client settings, preserving unrelated
hooks and Ghostty notification settings. Restart clients to load the changes.

Herdr updates through Homebrew. Keep session data, logs, generated hooks, plugin
checkouts, and plugin configuration under their normal home-directory locations.
The dotfiles source contains settings and installation choices.

## Ghostty and Fish

Ghostty opens Fish. Run `rtk proxy herdr` when a persistent workspace is useful;
it launches or attaches to Herdr's default session inside the current terminal.
Inside Herdr, use its panes and tabs for additional tasks. Ghostty's `Cmd`
shortcuts still operate on the outer window, tab, or split.

`Ctrl+B`, then `q` detaches the Herdr client and returns to the original Fish
shell; agents and commands in Herdr keep running. Run `rtk proxy herdr` there
to reattach. Closing the outer Ghostty window also leaves Herdr's session alive.
Use Herdr's explicit stop command only when stopping those processes is intended.

| Key inside Herdr | Action |
|---|---|
| `Ctrl+B`, then `?` | Show current Herdr bindings |
| `Ctrl+B`, then `v` / `-` | Split right / down |
| `Ctrl+B`, then `c` | New Herdr tab |
| `Ctrl+B`, then `f` | Open or toggle the file viewer in a split |
| `Ctrl+B`, then `Shift+F` | Open or toggle the file viewer in a tab |
| `Ctrl+click` on a GitHub issue/PR URL | Open the GitHub preview plugin |

Herdr owns the `Ctrl+B` prefix; use Fish's `gb` abbreviation for branch selection inside it.
Ghostty's `Cmd` shortcuts and existing `c`/`cx` abbreviations retain their roles.

Fish's Tab completes commands and arguments in Herdr panes. For example,
`herdr --ma` completes to `herdr --machine`, and
`herdr agent start --kind cod` completes to `codex`. Homebrew installs Herdr's
version-matched Fish completion; `fish/config.fish` excludes Herdr from Carapace
so its older definitions cannot replace that completion. No extra Fish plugin
is needed. See [Fish completion](https://fishshell.com/docs/current/interactive.html#tab-completion).
On an empty command line, Tab keeps the existing Television history picker;
`Ctrl+T` opens Television's context picker. After changing Fish config, use a
new pane or `exec fish` in an idle shell to load it.

## Selected Plugins

### Neovim: Signalbox

[nwiizo/signalbox.nvim](https://github.com/nwiizo/signalbox.nvim) is already
configured in [`nvim/lua/plugins/ai.lua`](../nvim/lua/plugins/ai.lua), using the
local checkout under `~/ghq/github.com/nwiizo/signalbox.nvim`. It provides another
entrypoint alongside the Herdr CLI and existing Codex/Claude integrations.

Press `<C-g>` or run `:Signalbox` to open the attention board. Inspect the
read-only preview, attach explicitly with Enter, and use `<C-g>` to return to
the board. Starting an agent, resuming a conversation, and sending a prompt
are explicit actions. `:SignalboxHealth` checks its backend and integrations.

The existing `VeryLazy` setup starts state monitoring after Neovim launches and
may start Herdr's detached server. Ghostty still opens Fish; attaching the Herdr
TUI and starting agents remain manual actions. See the
[Neovim guide](../nvim/README.md) for its other AI entrypoints.

### Herdr Plugins

| Plugin | Installation ref | Purpose |
|---|---|---|
| [herdr-file-viewer](https://github.com/smarzban/herdr-file-viewer) | `v1.18.0` | Read files and Git diffs; uses existing `bat` and `delta`, with a plain-text fallback for Markdown |
| [GitHub Link Preview](https://github.com/ogulcancelik/herdr-plugin-examples/tree/18709cdc851dd63ed0543eb8388343a5446fd8d8/github-link-preview) | `18709cdc851dd63ed0543eb8388343a5446fd8d8` | Read issue/PR details through the existing `gh` login when a link is clicked |

These plugins open on explicit user actions and do not start agents.
The installer uses the reviewed refs for missing plugins and keeps existing
installations, including local links and user-selected versions. Update a
plugin deliberately with Herdr's native plugin commands after checking its
current manifest, dependencies, and compatibility.

Herdr's native [integrations](https://herdr.dev/docs/integrations/) and
[plugin commands](https://herdr.dev/docs/plugins/) own the installed files;
do not copy generated hook or plugin state into this repository.

## Local Skill and Agent

The [Herdr skill](../.agents/skills/herdr/SKILL.md) is shared through the normal
dotfiles skill links. Its [operation contracts](../.agents/skills/herdr/references/operations.md)
cover targeting, delegated ownership, delivery uncertainty, task verification,
and persistence, based on current Herdr documentation and installed help.

The `home-herdr-operator` persona is available as a
[Claude Code agent](../.agents/agents/home-herdr-operator.md) and a
[Codex subagent](../.agents/codex/agents/home-herdr-operator.toml).
Use it for a defined setup, diagnosis, or authorized coordination assignment;
it keeps the caller's execution policy and does not create workers on invocation.
For example, ask it to diagnose an integration or coordinate a named, authorized
task with its owned paths and verification. Application code stays with that
task's implementation owner.
The Codex definition follows the [custom-agent schema](https://learn.chatgpt.com/docs/agent-configuration/subagents#custom-agents)
and inherits the parent's permissions, provider, and model defaults.

A Herdr live-agent name and a client persona are different. Claude Code's
installed CLI supports `claude --agent home-herdr-operator` for a session.
For Codex, request the registered `home-herdr-operator` subagent through the
parent agent; its installed CLI has no corresponding `--agent` switch.
New client sessions discover updated definitions.

## Validation

From the repository root:

```sh
rtk proxy herdr --version
rtk proxy herdr config check
rtk proxy herdr integration status
rtk proxy herdr plugin list
rtk proxy bash scripts/tests/herdr-integrations.sh
rtk proxy fish --no-config fish/tests/herdr_completion.fish
rtk proxy ./scripts/audit-agent-config.sh
rtk proxy ghostty +validate-config --config-file=ghostty/config
```

Inside Neovim, use `:SignalboxHealth` (or `:checkhealth signalbox`) and `<C-g>`
to verify the editor interface. It shares Herdr's session and agent state.

The integration regression uses an isolated home, the installed Herdr binary,
and fixture settings. It verifies coexistence with Ghostty notifications and
unrelated hooks, plus repeat installation. It does not log in, start agents,
or install plugins from the network.

Herdr config changes use `rtk proxy herdr server reload-config` for the intended
running session, or take effect when a new server starts. Skills and agent hooks
load in new Claude Code/Codex sessions. Test the actual UI from a Herdr pane;
outside Herdr, setup and configuration checks do not authorize controlling
another client's focused pane.
