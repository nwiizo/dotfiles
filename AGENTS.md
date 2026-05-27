# dotfiles Agent Guide

This guide applies to the whole repository.

## Repository Scope

Personal macOS development environment. Nix/Home Manager is no longer part
of the active setup; Homebrew owns binaries and this repo owns config files
via direct symlinks.

| Path | Purpose |
|---|---|
| `Brewfile` | Homebrew packages that replace the old Nix profile |
| `scripts/` | Bootstrap, symlink, and plugin install helpers |
| `fish/` | Fish `config.fish`, Fisher plugin list, functions, and `conf.d` patches |
| `nvim/` | Neovim (LazyVim) config |
| `ghostty/` | Ghostty terminal config |
| `warp/` | Warp keybindings, themes, and workflows |
| `git/` | Git config and helper scripts |
| `bat/`, `atuin/`, `tealdeer/`, `gh/` | Tool config files |

Reference-only:

- `archive/` — old configs. Do not edit unless explicitly requested.

## Live Config Reality

`scripts/link.sh` symlinks repo files into `~/.config`, `~/.warp`, and
`~/.local/bin`. Do not edit generated/live files directly; edit the repo
source, then re-run `./scripts/link.sh` when adding/removing linked files.

| You want to change ... | Edit ... |
|---|---|
| Fish shell init / env / abbreviations / integrations | `fish/config.fish` |
| Fish plugins | `fish/fish_plugins`, then `fish scripts/install-fish-plugins.fish` |
| Fish prompt / AI helpers / jj wrappers | `fish/functions/*.fish` |
| Fish conf.d patch | `fish/conf.d/zz_sponge_compat.fish` |
| Neovim plugins / options | `nvim/lua/...` |
| Ghostty | `ghostty/config` |
| Warp | `warp/keybindings.yaml`, `warp/themes/*.yaml`, `warp/workflows/*.yaml` |
| Git / GitHub config | `git/config`, `gh/config.yml` |
| Bat / Atuin / tealdeer | `bat/config`, `atuin/config.toml`, `tealdeer/config.toml` |
| Packages | `Brewfile` |

## Apply Changes

| Change | Apply |
|---|---|
| Edit existing symlinked config file | Restart the owning app or open a new shell |
| Add/remove `fish/functions/*.fish` or Warp workflows | `./scripts/link.sh` |
| Change Fish plugins | `fish scripts/install-fish-plugins.fish` |
| Change Homebrew packages | `brew bundle --file Brewfile` |
| Full bootstrap | `./scripts/bootstrap.sh` |

## Change Rules

- Preserve existing structure and style. Keep edits scoped.
- Do not revert unrelated user changes.
- Keep `archive/` untouched unless the user explicitly asks for archive work.
- Neovim plugin specs go under `nvim/lua/plugins/`.
- Do not reintroduce Nix, Home Manager, or nix-darwin into active config.

## Validation

For symlink/bootstrap changes:

```bash
./scripts/link.sh
fish scripts/install-fish-plugins.fish
brew bundle check --file Brewfile
```

For Fish changes:

```bash
fish -n fish/config.fish
for f in fish/functions/*.fish; do fish -n "$f" || exit 1; done
```

For Neovim changes:

```bash
stylua --check nvim/lua
nvim --headless '+lua print("nvim-config-ok")' +qa
```

For AI plugin changes:

```bash
nvim --headless '+lua require("lazy").load({ plugins = { "CopilotChat.nvim", "avante.nvim", "codecompanion.nvim", "claudecode.nvim" } }); print("ai-plugins-ok")' +qa
```

## Sync And Commit

- Commit only related files.
- After successful commit, push `main` to `origin` when requested.
- Repo root is intentionally minimal; keep new files in subdirectories unless
  the file is a top-level entry point like `Brewfile` or `README.md`.
