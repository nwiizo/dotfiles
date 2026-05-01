# Warp Terminal Configuration

Active alongside [Ghostty](../ghostty/). Both are managed by Home Manager.

Warp's strengths complement Ghostty:

- **Agent Mode** (`cmd-i`) — built-in AI assistant for command authoring,
  debugging, and workflow automation.
- **Block-based output** — every command's output is a navigable block;
  copy, bookmark, and re-run with two keystrokes.
- **Notebooks** — runnable / shareable command sequences.
- **Warp Drive** — save and parameterize frequently-used commands.

## Files

| Path | Role |
|---|---|
| `keybindings.yaml` | Pane / block / tab keybindings (tmux-like + vim navigation + Ghostty-style scroll) |
| `themes/custom.yaml` | Theme overrides (hides the tab bar) |
| `themes/catppuccin-mocha.yaml` | Custom theme matching `ghostty/config`'s palette |
| `workflows/*.yaml` | Reusable command templates (open via `Cmd+\` Warp Drive, or search by name) |

Both are live symlinks via Home Manager (`home/warp.nix`); edits land at
`~/.warp/...` immediately on save. Warp restart picks them up.

## Notable bindings

### Pane operations (tmux-like)

| Key | Action |
|---|---|
| `Cmd+D` / `Cmd+Shift+D` | Split right / down |
| `Shift+Cmd+|` / `Shift+Cmd+_` | Split left / up |
| `Ctrl+H/J/K/L` | Navigate (vim-style) |
| `Shift+Ctrl+H/J/K/L` | Resize (vim-style) |
| `Cmd+Shift+Return` | Toggle zoom |
| `Cmd+W` | Close pane |

### Block operations (Warp-only)

| Key | Action |
|---|---|
| `Cmd+Up` / `Cmd+Down` | Select block above / below |
| `Cmd+Shift+C` | Copy block output |
| `Cmd+Shift+B` | Bookmark block |
| `Cmd+K` | Clear blocks |

### AI / Search

| Key | Action |
|---|---|
| `Cmd+I` | Agent Mode (Warp default) |
| `Ctrl+\`` | Natural language command (legacy AI prompt) |
| `Ctrl+R` | Command search (history) |
| `Cmd+\` | Warp Drive |
| `Cmd+Shift+P` | Command palette |
| `Cmd+F` | Search transcript (Warp default) |

## Settings (`~/.warp/settings.toml`)

Auto-managed by the Warp app — not tracked in this repo. Adjust via
`Cmd+,` (Preferences). Personal preferences (font, theme, cursor) live
there.

### Recommended UI settings (migrated from `ghostty/config`)

Set these in **Settings → ...** to mirror the Ghostty experience:

| Setting | Value | Where |
|---|---|---|
| Theme | `catppuccin-mocha` | Appearance → Themes |
| Font | Hack Nerd Font Mono, size 14 | Appearance → Text |
| Cursor | Bar, blink | Appearance → Cursor |
| Tab bar | Hidden | Appearance → Tab Bar (or via `themes/custom.yaml`) |
| Confirm before closing tabs | On | Settings → Tabs |
| Inherit working directory (new tab/pane) | On | Settings → Subshells (Warp default) |
| Scrollback limit | ~100k lines | Settings → Terminal |
| Notify on long-running command (≥5s) | On | Settings → Notifications |
| Bell behavior | Title flash + attention | Settings → Notifications |
| Copy on select | On | Settings → Editor |
| Agent Mode | **Off** | AI → Agent Mode |
| Block-based output | On (default) | Settings → Editor |

These are settings the Warp app stores in `settings.toml`; they aren't
declarative in this repo. Apply once and Warp persists them.

## Workflows

Bundled command templates accessible via `Cmd+\` (Warp Drive → Workflows)
or by typing the name into the command input:

| Workflow | Action |
|---|---|
| Update everything | Run `update_all` |
| Home Manager switch | `home-manager switch --flake .#nwiizo` |
| Home Manager build (dry validate) | `nixfmt --check` + `home-manager build` |
| Neovim Lazy sync | `nvim --headless +Lazy! sync +qa` |
| ghq fzf cd | Pick a repo with fzf and cd into it |
| AI context (clipboard) | `ai_context | pbcopy` |
| jj colocate here | `jj git init --colocate` |
| Git cleanup merged branches | Delete merged-into-current local branches |
| Kubernetes context switch | `kubectl config use-context {{context}}` (templated) |

Add new workflows by dropping a YAML file in `warp/workflows/` and
re-running `home-manager switch`. Workflows created from Warp's UI
land in `~/.warp/workflows/` directly and coexist with the symlinked
ones.

## Install via Home Manager

`home/warp.nix` declares the keybindings, themes, and workflows as
live symlinks. After `home-manager switch`, restart Warp to pick up
the new keybindings.

## Removing

If you want to retire Warp again, drop `home/warp.nix` from
`home/default.nix` imports, run `home-manager switch`, and `mv
warp/ archive/warp/`.
