# Repository Guidelines

## Project Structure & Module Organization

This repository manages a personal macOS development environment. Homebrew
packages are listed in `Brewfile`; configuration sources live in tool-specific
directories such as `fish/`, `nvim/`, `ghostty/`, `warp/`, `git/`, `gh/`,
`bat/`, `atuin/`, and `tealdeer/`. Helper scripts live in `scripts/`.

Agent assets are sourced from `.agents/`. Claude Code project entrypoints in
`.claude/` and Codex project agents in `.codex/` are symlinks into `.agents/`.
`archive/` is reference-only; do not edit it unless explicitly requested.

## Build, Test, and Development Commands

- `./scripts/bootstrap.sh` installs packages, links configs, and installs Fish plugins.
- `./scripts/link.sh` links repo sources into `~/.config`, `~/.warp`,
  `~/.local/bin`, `~/.claude`, `~/.agents`, and `~/.codex`.
- `fish scripts/install-fish-plugins.fish` applies `fish/fish_plugins`.
- `brew bundle check --file Brewfile` verifies Homebrew dependencies.
- `./scripts/audit-agent-config.sh` checks agent symlinks, stale references,
  generated files, Codex agent TOML, and secrets.

## Coding Style & Naming Conventions

Keep changes scoped and follow the existing layout. Fish functions use
`fish/functions/<name>.fish`; Neovim plugin specs go under `nvim/lua/plugins/`.
Reusable skills use `.agents/skills/<name>/SKILL.md`. Reviewer or planner
personas belong in `.agents/agents/`; Codex custom agents belong in
`.agents/codex/agents/*.toml`.

## Testing Guidelines

Run checks matching the changed area:

```bash
fish -n fish/config.fish
for f in fish/functions/*.fish; do fish -n "$f" || exit 1; done
stylua --check nvim/lua
nvim --headless '+lua print("nvim-config-ok")' +qa
./scripts/link.sh
./scripts/audit-agent-config.sh
```

For package changes, also run `brew bundle check --file Brewfile`.

## Commit & Pull Request Guidelines

Use concise conventional commits, for example
`chore(agents): align claude and codex workflows`. In this jj repository,
finish a change with `jj describe`, open a fresh change with `jj new`, then
move `main` and push only when requested.

## Security & Configuration Tips

Do not track sessions, logs, caches, credentials, local settings, or generated
state. Edit repo sources, not linked targets under `~/.config` or agent home
directories. Run `git secrets --scan` before publishing agent or history-derived
assets.
