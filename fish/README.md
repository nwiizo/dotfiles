# Fish Shell

This directory holds source files referenced by Home Manager. The actual fish
configuration is generated from [`../home/fish.nix`](../home/fish.nix).

## Layout

| Path | Role |
|---|---|
| `functions/` | Custom fish functions (prompt, AI helpers, jj wrappers, `update_all`, etc.) — symlinked into `~/.config/fish/functions/` by HM |
| `conf.d/zz_sponge_compat.fish` | Compatibility patch for sponge plugin on fish 4.x |
| `CLAUDE.md` | Editing rules for AI assistants |

## How edits flow

1. Edit `home/fish.nix` (or files under `fish/functions/`).
2. `home-manager switch --flake .#nwiizo` (or `update_all`).
3. New shells pick up changes; reload current with `exec fish`.

## What's not here

- `config.fish` — generated; lives at `~/.config/fish/config.fish` as a
  symlink into `/nix/store`.
- Plugins — managed by HM via `programs.fish.plugins`. See `flake.nix` for
  non-nixpkgs sources.
- Auto-generated init scripts (`atuin`, `direnv`, `zoxide`) — produced by
  `programs.{atuin,direnv,zoxide}.enableFishIntegration`.
