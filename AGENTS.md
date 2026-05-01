# dotfiles Agent Guide

This guide applies to the whole repository.

## Repository Scope

Personal macOS development environment, managed end-to-end by **standalone
Home Manager** (no nix-darwin; sudo not required).

| Path | Purpose |
|---|---|
| `flake.nix`, `flake.lock` | Flake entry point and pinned inputs |
| `home/` | Home Manager modules (`default.nix`, `fish.nix`, ...) |
| `fish/functions/`, `fish/conf.d/` | Source files referenced from `home/fish.nix` |
| `nvim/` | Neovim (LazyVim) config, symlinked by HM |
| `ghostty/` | Ghostty terminal config, symlinked by HM |
| `git/` | Helper scripts (e.g. `power_pull.sh`) installed via `home.file` |

Reference-only:

- `archive/` — old configs. Do not edit unless explicitly requested.
- Starship and Fisher are no longer used; the prompt is native Fish, plugins
  live in `programs.fish.plugins`.

## Live Config Reality

`~/.config/fish`, `~/.config/nvim`, `~/.config/ghostty`, `~/.config/git`,
`~/.config/gh`, `~/.config/bat` are all populated by Home Manager. **Do
not edit them directly** — edit the repo source.

| You want to change ... | Edit ... |
|---|---|
| Fish shell init / behavior | `home/fish.nix` (`shellInit` / `interactiveShellInit`) |
| Fish abbreviations | `home/fish.nix` (`shellAbbrs`) |
| Fish wrapper functions (inline) | `home/fish.nix` (`functions`) |
| Fish prompt / AI helpers / jj wrappers | `fish/functions/*.fish` |
| Fish plugin list | `home/fish.nix` (`plugins`) and `flake.nix` for non-nixpkgs sources |
| Neovim plugins / options | `nvim/lua/...` |
| Ghostty | `ghostty/config` |
| Git / GitHub config | `home/git.nix` (`programs.git.settings`, `programs.gh.settings`) |
| Env vars (EDITOR / GOPATH / ...) | `home/default.nix` (`home.sessionVariables`) |
| Packages (general CLI) | `home/packages.nix` (`home.packages`) |

### When `home-manager switch` is required

`nvim/`, `fish/functions/*.fish`, and `fish/conf.d/zz_sponge_compat.fish`
go through `mkOutOfStoreSymlink` — edits are visible **immediately** at
`~/.config/...` without rebuilding. Run `switch` only when the **structure**
changes (new file added/removed, anything in `home/*.nix` or `flake.nix`):

| Change | Switch needed? | Why |
|---|---|---|
| Edit existing `nvim/lua/**.lua` | No | Live dir symlink |
| **Add or remove** any file under `nvim/` | No | Live dir symlink (nvim picks it up via lazy.nvim spec discovery) |
| Edit existing `fish/functions/*.fish` | No (`functions -e <name>` to refresh in current shell) | Live per-file symlink |
| **Add** a new `fish/functions/<x>.fish` | Yes | Needs a new `xdg.configFile` entry in `home/fish.nix` |
| Edit `fish/conf.d/zz_sponge_compat.fish` | No (open new shell) | Live per-file symlink |
| Edit `home/*.nix` (abbr / package / programs.X / sessionVar) | Yes | HM regenerates `config.fish`, env, etc. |
| Edit `flake.nix` / `flake.lock` | Yes | Re-evaluate inputs |
| Edit `ghostty/config`, `git/power_pull.sh`, anything else passed via `xdg.configFile` / `home.file` | Yes | Frozen-store copy (not a live link) |

Apply with `home-manager switch --flake .#nwiizo` (or `update_all`).

For concrete recipes (env vars, abbreviations, fish functions, file
symlinks, flake inputs, ...) see [`home/HOWTO.md`](./home/HOWTO.md).
The matching skills are `.agents/skills/add-package` (package only)
and `.agents/skills/add-nix-config` (general settings).

## Change Rules

- Preserve existing structure and style. Keep edits scoped.
- Do not revert unrelated user changes.
- Keep `archive/` untouched.
- Neovim plugin specs go under `nvim/lua/plugins/`.
- Do **not** introduce nix-darwin (sudo-free standalone HM is the constraint).
- Brewfile remains imperative (Homebrew is *not* declaratively managed).

## Validation

For Nix / Home Manager changes:

```bash
nixfmt --check ./flake.nix ./home/*.nix
home-manager build --flake .#nwiizo
home-manager switch --flake .#nwiizo
```

`home-manager build` covers fish syntax (it generates `config.fish`) and
ensures `nvim/`/`ghostty/` references resolve. Direct `fish -n` checks on
`fish/functions/*.fish` are still useful for files referenced from
`xdg.configFile`:

```bash
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
- Repo root is intentionally minimal — keep new files in subdirectories.
