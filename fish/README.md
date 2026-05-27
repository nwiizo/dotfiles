# Fish Shell

This directory holds the active Fish configuration. `scripts/link.sh`
symlinks these files into `~/.config/fish/`.

## Layout

| Path | Role |
|---|---|
| `config.fish` | Main shell init, abbreviations, env vars, and tool integrations |
| `fish_plugins` | Fisher plugin list |
| `functions/` | Custom fish functions (prompt, AI helpers, jj wrappers, `update_all`, etc.) |
| `conf.d/zz_sponge_compat.fish` | Compatibility patch for sponge plugin on fish 4.x |
| `CLAUDE.md` | Editing rules for AI assistants |

## How edits flow

1. Edit `config.fish`, `fish_plugins`, or files under `functions/`.
2. Run `../scripts/link.sh` when adding/removing files.
3. Run `fish ../scripts/install-fish-plugins.fish` when changing plugins.
4. New shells pick up changes; reload current with `exec fish`.

## What's not here

- `fish_variables` — local Fish universal variables/runtime state.
- Tool caches and histories (`atuin`, `fzf`, shell history).
