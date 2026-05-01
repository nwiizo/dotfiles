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
| `keybindings.yaml` | Pane / block / tab keybindings (tmux-like + vim navigation) |
| `themes/custom.yaml` | Theme overrides (currently just hides tab bar) |

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

## Install via Home Manager

`home/warp.nix` declares both files as live symlinks. After
`home-manager switch`, restart Warp to pick up the new keybindings.

## Removing

If you want to retire Warp again, drop `home/warp.nix` from
`home/default.nix` imports, run `home-manager switch`, and `mv
warp/ archive/warp/`.
