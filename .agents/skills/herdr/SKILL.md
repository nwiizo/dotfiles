---
name: herdr
description: Set up and use Herdr, the default persistent terminal workspace manager for this environment. Use for Herdr configuration, plugins, client integrations, and authorized pane or agent coordination.
---

# Herdr Workspaces

Use the installed binary's guidance: `rtk proxy herdr --help` for command groups
and `rtk proxy herdr --skill` before controlling panes or agents. Read the
relevant group's help for current syntax. Bare `herdr` attaches the TUI.
Ghostty starts Fish; enter Herdr when needed, without adding automatic attachment
to terminal or shell startup.

Neovim also exposes [signalbox.nvim](https://github.com/nwiizo/signalbox.nvim)
through `<C-g>` and `:Signalbox` for the attention board and explicit agent
actions. Use that interface, the Herdr CLI, or existing Codex/Claude entrypoints
as appropriate; no single entrypoint is required.

For control, first check that `HERDR_ENV=1`. Use the caller's pane context or
identifiers returned by Herdr, preserve its working directory, and keep focus
with the user for background work. Outside Herdr, continue installation and
configuration work, but do not control another client's focused session.
The user's choice of Herdr as the default does not authorize additional agents;
apply the current task's delegation authorization.

For pane/agent coordination, uncertain delivery, or lifecycle diagnosis, read
[operation contracts](references/operations.md). Distinguish an agent being
ready from its assigned work being complete. Use `home-herdr-operator` when a
separate Herdr operations role is explicitly requested; choosing this skill
does not itself launch that role or additional agents.

Herdr is Homebrew-managed: record it in `Brewfile` and update it with Homebrew.
Use `rtk proxy bash scripts/install-herdr.sh` from the dotfiles repository for
the selected plugins and Claude Code/Codex integrations; `--integrations-only`
refreshes hooks without installing plugins. It preserves independently installed plugins.
Read the repository's [Herdr guide](../../../herdr/README.md) when changing this setup.

Validate saved settings with `rtk proxy herdr config check`, inspect local
installation state with `rtk proxy herdr integration status` and
`rtk proxy herdr plugin list`, and keep logs, sessions, hooks, and plugin state
outside Git. New client sessions load updated hooks and skills.
