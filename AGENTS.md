# dotfiles Agent Guide

This guide applies to the whole repository.

## Repository Scope

Personal macOS development environment.

Active areas:

| Path | Purpose |
|---|---|
| `fish/` | Fish shell config, functions, plugins, docs |
| `nvim/` | Neovim LazyVim config |
| `ghostty/` | Ghostty terminal config |
| `git/` | Git helper scripts |
| `flake.nix`, `home.nix`, `flake.lock` | Standalone Home Manager setup |

Reference only:

- `archive/` contains old configs. Do not edit unless explicitly requested.
- Starship is archived/reference in this repo; the current active prompt is native Fish.

## Important Local Reality

The live config directories are real directories, not symlinks:

- `~/.config/fish`
- `~/.config/nvim`

When changing Fish or Neovim runtime files, update both the repo copy and the
live config copy unless the user explicitly asks for repo-only changes. Verify
with `diff -u` after editing.

## Change Rules

- Preserve existing structure and style. Keep edits scoped.
- Do not revert unrelated user changes.
- Keep `archive/` untouched.
- For Fish, keep `config.fish` section organization and put reusable commands in
  `fish/functions/*.fish`.
- For Neovim, keep plugin specs under the existing modules in
  `nvim/lua/plugins/`.
- For AI tooling, prefer context-quality improvements over adding another AI
  plugin. Current AI surface is CopilotChat, Avante, CodeCompanion, Claude Code,
  and Fish helpers.
- Home Manager is standalone flake based. Do not introduce nix-darwin unless
  explicitly requested.

## Validation

Run relevant checks before finalizing:

```bash
fish -n fish/config.fish
for f in fish/functions/*.fish; do fish -n "$f" || exit 1; done

stylua --check nvim/lua
nvim --headless '+lua print("nvim-config-ok")' +qa
```

For AI plugin changes:

```bash
nvim --headless '+lua require("lazy").load({ plugins = { "CopilotChat.nvim", "avante.nvim", "codecompanion.nvim", "claudecode.nvim" } }); print("ai-plugins-ok")' +qa
```

For Home Manager changes:

```bash
nix build .#homeConfigurations.nwiizo.activationPackage --dry-run
home-manager build --flake .#nwiizo
home-manager switch --flake .#nwiizo
```

## Sync And Commit

- If the user asks for sync/commit, commit only related files.
- `nvim/lua/plugins/lsp.lua` was previously synced; future unrelated changes
  should not be bundled.
- After successful commit, push `main` to `origin` when requested.

