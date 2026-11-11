# Herdr

Herdr is the default persistent terminal workspace manager. Ghostty provides
the terminal window; Herdr runs inside it and starts managed Fish login shells
in its panes. Claude Code, Codex, and Copilot CLI run as coding agents.

## Installation and Ownership

| Source | Role |
|---|---|
| `../Brewfile` | Homebrew `herdr` formula |
| `config.toml` | Linked to `~/.config/herdr/config.toml` |
| `plugins/reviewr.toml` | Linked to Herdr's `persiyanov.reviewr` plugin config |
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
The installer refreshes integrations for installed Claude Code/Codex clients
and Copilot CLI when its config directory has been initialized. Copilot uses
`COPILOT_HOME` or `~/.copilot`; when it is absent, setup skips that integration
until Copilot has been started once. The native installer owns the hook version.
`--integrations-only` refreshes those hooks without installing plugins.
The native installer merges its hooks into client settings, preserving unrelated
hooks and Ghostty notification settings. Restart clients to load the changes.

Herdr updates through Homebrew. Keep session data, logs, generated hooks, plugin
checkouts, and plugin configuration under their normal home-directory locations.
The dotfiles source contains settings and installation choices.

### Remote machines

For an existing remote machine, inspect its binary, linked config,
and dirty dotfiles before applying setup. Preserve its installed Fish path in
`terminal.default_shell`; a user-managed Herdr installation does not require
adding Homebrew. Apply selected managed sources to that machine's checkout,
run `scripts/link.sh` and `scripts/install-herdr.sh`, validate, then reload the
running session's config from a Herdr pane. Do not restart the shared server.
Absent coding clients are skipped rather than installed or logged in.

Use one workspace per project and tabs for branches or roles. Keep a handoff
orchestrator in a dedicated workspace, project monitors beside their project,
and machine-wide utilities such as keepawake under Terminal. Move live panes
with `pane move --no-focus`, re-resolve IDs after each move, and verify terminal
identities and processes survive. Workspace labels describe purpose; agent
states already show progress, so avoid baking temporary status into names.

## Ghostty and Fish

Ghostty opens Fish. Run `rtk proxy herdr` when a persistent workspace is useful;
it launches or attaches to Herdr's default session inside the current terminal.
Inside Herdr, use its panes and tabs for additional tasks. Ghostty's `Cmd`
shortcuts still operate on the outer window, tab, or split.

`Ctrl+Q`, then `q` detaches the Herdr client and returns to the original Fish
shell; agents and commands in Herdr keep running. Run `rtk proxy herdr` there
to reattach. Closing the outer Ghostty window also leaves Herdr's session alive.
Use Herdr's explicit stop command only when stopping those processes is intended.

| Key inside Herdr | Action |
|---|---|
| `Ctrl+Q`, then `?` | Show current Herdr bindings |
| `Ctrl+Q`, then `[` / `]` | Focus the previous / next workspace |
| `Ctrl+Q`, then `Shift+C` | Enter copy mode (moved from `[` to keep workspace navigation together) |
| `Ctrl+Q`, then `\|` (or `v`) / `-` | Split right / down |
| `Ctrl+Q`, then `c` | New Herdr tab |
| `Ctrl+Q`, then `f` | Open or toggle the file viewer in a split |
| `Ctrl+Q`, then `Shift+F` | Open or toggle the file viewer in a tab |
| `Ctrl+Q`, then `Ctrl+R` | Open reviewr over the workspace for diff comments |
| `Ctrl+Q`, then `d` | Review documents in the current folder with Annotate |
| `Ctrl+Q`, then `Shift+O` | Review the agent's recent replies with Annotate |
| `Ctrl+Q`, then `t` | Review recent terminal output, such as build/test logs |
| `Ctrl+Q`, then `Ctrl+A` | Comment on selected terminal text |
| `Ctrl+Q`, then `m` | Manage saved annotations |
| `Ctrl+Q`, then `Ctrl+V` | Paste annotations into the agent prompt without submitting |
| `Ctrl+Q`, then `Ctrl+E` | Equalize pane sizes immediately |
| `Ctrl+Q`, then `a` / `Shift+A` | Focus the next / previous agent |
| `Ctrl+Q`, then `o` | Focus the agent from the visible notification |
| `Ctrl+click` on a GitHub issue/PR URL | Open the GitHub preview plugin |

Herdr uses `Ctrl+Q` as its prefix. Fish's `Ctrl+B` branch picker also works inside
Herdr. Press `Ctrl+Q` twice to send one literal `Ctrl+Q` to the pane, for example
for Neovim/Television's quickfix action.
Ghostty's `Cmd` shortcuts and existing `c`/`cx` abbreviations retain their roles.

This setting applies to the Herdr TUI. Herdr 0.9.5's direct `agent attach` and
`terminal attach` interfaces keep their own `Ctrl+B`, then `q` detach sequence.

Fish's Tab completes commands and arguments in Herdr panes. For example,
`herdr --ma` completes to `herdr --machine`, and
`herdr agent start --kind cod` completes to `codex`. Homebrew installs Herdr's
version-matched Fish completion; `fish/config.fish` excludes Herdr from Carapace
so its older definitions cannot replace that completion. No extra Fish plugin
is needed. See [Fish completion](https://fishshell.com/docs/current/interactive.html#tab-completion).
On an empty command line, Tab keeps the existing Television history picker;
`Ctrl+T` opens Television's context picker. After changing Fish config, use a
new pane or `exec fish` in an idle shell to load it.

## Settings

`config.toml` sets only the values that differ from Herdr's defaults, following
the [configuration guide](https://herdr.dev/docs/configuration/). Print the
defaults with `rtk proxy herdr --default-config`.

| Setting | Behavior |
|---|---|
| `keys.prefix = "ctrl+q"` | Enter prefix mode with `Ctrl+Q`; every `prefix+…` binding follows this setting |
| `keys.previous_workspace = "prefix+["`, `next_workspace = "prefix+]"` | Step through workspaces; `keys.copy_mode = "prefix+shift+c"` frees `[` for navigation |
| `terminal.default_shell`, `shell_mode = "login"` | New panes start Homebrew Fish as a login shell, matching Ghostty |
| `keys.next_agent = "prefix+a"`, `previous_agent = "prefix+shift+a"` | Step through agents without opening the Goto picker; no default binding uses these keys |
| `ui.status_indicators = "symbols"` | Agent states differ by shape as well as color |
| `ui.agent_panel_sort = "priority"` | The agent panel lists agents that need input first |
| `ui.sidebar.agents.rows_by_agent` | Claude Code and Codex rows add their terminal title, which names the current task |
| `ui.show_agent_labels_on_pane_borders = true` | Split pane borders name their agent unless the pane has a manual name |
| `ui.tab_bar_right = [{ type = "zoom" }]` | The tab bar shows ZOOM while a zoomed pane hides the others |
| `ui.toast.delivery = "terminal"` | Ghostty shows a desktop notification when an agent in a background tab finishes or needs input; the active tab stays silent |
| `experimental.switch_ascii_input_source_in_prefix` | After `Ctrl+Q`, prefix keys are read as ASCII even while Japanese input is active; the input source returns afterwards |
| `experimental.reveal_hidden_cursor_for_cjk_ime` with `cjk_ime_agents = ["claude", "codex"]` | The IME candidate window follows the prompt cursor in Claude Code and Codex panes; other apps keep their hidden cursor |

Defaults kept on purpose:

- `experimental.pane_history` stays off because saved pane output can contain
  secrets. Detach/reattach keeps live screens, and Claude Code/Codex resume
  through `session.resume_agents_on_restore` after a server restart.
- The theme stays Herdr's default `catppuccin`, matching Ghostty's Catppuccin Mocha.
- `ui.mouse_capture` stays on so `Ctrl+click` reaches the GitHub preview plugin.
- `advanced.scrollback_limit_bytes` stays at 10 MB per pane, below Ghostty's
  100 MB, because every agent pane keeps its own buffer. Use `Ctrl+Q`, then `e`
  to open a pane's scrollback in the editor.
- Updates come from Homebrew; `herdr update` is disabled for Homebrew installs.

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
| [reviewr](https://github.com/persiyanov/herdr-reviewr/tree/92c51e2bd4e2caf42fa00bc193ae2f48955df64f) | `92c51e2bd4e2caf42fa00bc193ae2f48955df64f` (`v0.49.1`) | Review diffs and send line comments to the agent on an explicit action |
| [Annotate](https://github.com/plannotator/herdr-annotate/tree/a9973b43c1fc90044a9f15755e310e12b8465abb) | `a9973b43c1fc90044a9f15755e310e12b8465abb` (`0.9.9`) | Review design documents, README files, agent replies and terminal output; retain feedback for the agent |
| [Equalize Panes](https://github.com/shibayu36/herdr-equalize-panes/tree/0c1d940e9af09c632a48a5b179753ef25056ff13) | `0c1d940e9af09c632a48a5b179753ef25056ff13` (`0.1.0`) | Balance the affected tab after a split or pane close/exit |

These refs were reviewed on 2026-11-09 against Herdr 0.9.5. Viewer/review panes
open on explicit user actions; the plugins do not start coding agents.
For reviewr, `plugins/reviewr.toml` disables automatic opening on worktree
creation and uses an overlay so existing worker panes keep their sizes.
Press `Ctrl+Q`, then `Ctrl+R` in the intended workspace, choose a file, select
lines with `v`, add a comment with `c`, and send the collected feedback with `s`.
Use `q` to close: it asks when comments are unsent. The shortcut uses `open`,
so pressing it again preserves the current review and its comments.
Unsent comments live only in that pane; `y` copies them if they need preserving.
reviewr does not post comments to GitHub PRs; its PR tab is read-only.

Annotate's Full install includes the pinned native annotation runtime and
plannotator-tui; its build steps verify downloaded binaries with SHA-256.
Use `d` after the prefix for Markdown/design review, `Shift+O` for agent replies,
or `t` for recent build/test output. Add comments in the review UI and submit
them explicitly with **Send** / `E`. Terminal selections can be saved with
`Ctrl+A` after the prefix, reviewed in `m`, and pasted with `Ctrl+V` after the
prefix; that paste action archives the notes and leaves submission to the user.
Annotation state and archives stay in the plugin's private runtime directories.

Equalize Panes redistributes the affected tab's split ratios when panes are
created, closed, or exit. Pane positions and processes are preserved. A manual
resize lasts until that tab's next split/close/exit; `Ctrl+Q`, then `Ctrl+E`
also balances it immediately. The plugin uses the system Perl and Herdr's local
socket API; it does not need a background service or another coding agent.

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
For authorized teams, [task coordination](../.agents/skills/herdr/references/task-coordination.md)
binds task/attempt IDs to results, separates overlapping writes with worktrees
or serial ownership, and verifies the integrated tree. Condition-based waits
avoid repeatedly reading every pane; plugin UI calls use explicit targets
instead of another client's focus.

### Orchestrator context handoff

Authorized orchestrators check their own context usage at assignment/monitoring
checkpoints. At 85% used (15% remaining), the
[handoff contract](../.agents/skills/herdr/references/orchestrator-handoff.md)
has them save a private handoff, start one fresh orchestrator in a workspace in
the same session, verify its receipt, and release ownership. After the old turn
ends, the successor closes only the verified old orchestrator workspace; shared
panes and linked worktrees are preserved. Workers continue through the transfer.

The rule is shared by Claude Code and Codex and carries the task's existing
permissions forward without another routine confirmation. It runs through the
agent's checkpoints, not a background hook/daemon, so it cannot interrupt a tool
exactly at 85%. Missing telemetry, failed startup, or an unsafe close keeps the
old workspace and reports the unresolved step. Runtime records live under
`${XDG_STATE_HOME:-$HOME/.local/state}/herdr-orchestrator/`, outside Git.

When the user explicitly asks for unattended agents launched like the `c`/`cx`
abbreviations, start Herdr workers with the same documented exception:

```sh
rtk proxy herdr agent start <name> --kind claude --pane <pane> -- --dangerously-skip-permissions
rtk proxy herdr agent start <name> --kind codex --pane <pane> -- --dangerously-bypass-approvals-and-sandbox
```

This removes approval prompts and sandboxing, so the task prompt must still name
the allowed operations, owned paths, and forbidden targets. Keep the guarded
launch as the default when no such request was made. Record which workers run
with the exception, and carry it forward when replacing a worker.

For long development runs, the
[development harness](../.agents/skills/home-development-harness/SKILL.md)
keeps conditions, decisions, evidence, and recovery instructions available to
the successor. New client sessions discover the updated guidance.

### Operations persona

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
unrelated hooks, Copilot initialization handling, plus repeat installation.
It does not log in, start agents,
or install plugins from the network.

Herdr config changes use `rtk proxy herdr server reload-config` for the intended
running session, or take effect when a new server starts. Skills and agent hooks
load in new Claude Code/Codex sessions. Test the actual UI from a Herdr pane;
outside Herdr, setup and configuration checks do not authorize controlling
another client's focused pane.
