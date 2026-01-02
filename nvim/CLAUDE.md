# CLAUDE.md - Neovim Configuration Guide

This file provides guidance to Claude Code and AI assistants when working with this Neovim configuration.

## Overview

This is a **NvChad v2.5-based Neovim configuration** optimized for:
- Rust, Go, TypeScript, Python development
- Multiple AI assistant integrations
- 2025 minimal UI workflow (statusline-less)

**Last Updated:** 2025-12-16
**Base:** NvChad v2.5 with lazy.nvim

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── chadrc.lua          # NvChad theme/UI config
│   ├── options.lua         # Neovim options
│   ├── mappings.lua        # Custom keymaps
│   ├── configs/
│   │   └── lspconfig.lua   # LSP server configurations
│   └── plugins/
│       └── init.lua        # All plugin definitions
├── stylua.toml             # Lua formatter config
└── lazy-lock.json          # Plugin version lock
```

---

## 2025 Minimal UI Architecture

This configuration follows a statusline-less workflow for maximum editing space:

### UI Components

| Component | Plugin | Purpose |
|-----------|--------|---------|
| **File info** | incline.nvim | Floating statusline (bottom-right) |
| **Mode indicator** | modes.nvim | Cursorline color changes by mode |
| **Command line** | noice.nvim | Floating cmdline (cmdheight=0) |
| **Buffer dimming** | vimade | Inactive buffers are dimmed |
| **Code peek** | overlook.nvim | Stackable floating popups for LSP |
| **File picker** | Snacks.nvim | Smart picker replaces bufferline |

### Key Settings

```lua
-- options.lua
cmdheight = 0      -- No command line (noice.nvim handles it)
laststatus = 0     -- No statusline (incline.nvim handles it)
showmode = false   -- No mode text (modes.nvim shows via color)
```

### incline.nvim Features

- File icon with filetype color
- Orange dot for unsaved files
- Diagnostics count (errors/warnings)
- Parent directory for generic filenames (init.lua → plugins/init.lua)
- Dimmed when window is unfocused

### modes.nvim Colors

| Mode | Color |
|------|-------|
| Insert | Cyan (#78ccc5) |
| Visual | Purple (#9745be) |
| Copy (yank) | Yellow (#f5c359) |
| Delete | Red (#c75c6a) |

---

## AI Plugin Strategy (2025)

This configuration includes **6 AI tools**. Here's when to use each:

### Primary: Copilot + CopilotChat
- **Use for:** Daily coding, inline completions, quick questions
- **Keymaps:** Automatic completions, `<leader>cc` for chat
- **Model:** claude-opus-4 (configurable)

### Secondary: Avante.nvim
- **Use for:** Complex refactoring, code generation with context
- **Keymaps:**
  - `<leader>aa` - Ask AI about current code
  - `<leader>ae` - Edit code with AI
  - `<leader>ar` - Refresh response
- **Features:** Cursor-like IDE experience, MCP integration

### Supplementary Tools

| Plugin | Use Case | Trigger |
|--------|----------|---------|
| **Cody (sg.nvim)** | Sourcegraph integration, codebase search | `<C-a>` in completion |
| **CodeCompanion** | Alternative chat interface | `<leader>cc`, `<leader>ct` |
| **claude-code.nvim** | Claude Code terminal | `<leader>cl` |
| **mcphub.nvim** | MCP server management | `:MCPHub` |

---

## Navigation & Search

### Snacks.nvim (Primary)
| Key | Description |
|-----|-------------|
| `<leader><leader>` | Smart picker (files + buffers + recent) |
| `<leader>sf` | Find files |
| `<leader>sg` | Grep search |
| `<leader>sb` | Buffers |
| `<leader>sr` | Recent files |
| `<leader>sc` | Commands |
| `<leader>sh` | Help pages |
| `<leader>sk` | Keymaps |
| `<leader>sd` | Diagnostics |
| `<leader>ss` | LSP symbols |

### Telescope (Secondary)
| Key | Description |
|-----|-------------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<C-p>` | Quick file find |

### File Explorer
| Key | Description |
|-----|-------------|
| `-` | Open parent directory (oil.nvim) |
| `<leader>e` | File explorer |

### Flash.nvim (Motion)
| Key | Description |
|-----|-------------|
| `s` | Jump to any character |
| `S` | Treesitter selection |

---

## Git Integration

### Snacks LazyGit
| Key | Description |
|-----|-------------|
| `<leader>gg` | Open LazyGit (files edit in current nvim) |
| `<leader>gl` | LazyGit log |
| `<leader>gf` | File history in LazyGit |

### Diffview

### Basic Operations
| Key | Description |
|-----|-------------|
| `<leader>gd` | Working tree diff |
| `<leader>gD` | Diff vs previous commit |
| `<leader>gs` | Staged changes |
| `<leader>gm` | Diff vs main branch |
| `<leader>gM` | Diff vs master branch |
| `<leader>gh` | Current file history |
| `<leader>gH` | Branch history |
| `<leader>gq` | Close diffview |
| `<leader>gt` | Toggle file panel |

### Inside Diffview
| Key | Description |
|-----|-------------|
| `<tab>` / `<s-tab>` | Next/prev file |
| `gf` | Open file |
| `-` / `s` | Stage/unstage |
| `S` | Stage all |
| `U` | Unstage all |
| `X` | Restore entry |
| `L` | Open commit log |
| `g?` | Show help |

### Conflict Resolution
| Key | Description |
|-----|-------------|
| `[x` / `]x` | Prev/next conflict |
| `<leader>co` | Choose ours |
| `<leader>ct` | Choose theirs |
| `<leader>cb` | Choose base |
| `<leader>ca` | Choose all |
| `dx` | Delete conflict |

### Gitsigns
| Key | Description |
|-----|-------------|
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `]c` / `[c` | Next/prev hunk |

---

## Code Jump & Peek (overlook.nvim)

| Key | Description |
|-----|-------------|
| `<leader>pd` | Peek definition (floating popup) |
| `<leader>pc` | Close all popups |
| `<leader>pu` | Restore last popup |
| `<leader>pU` | Restore all popups |
| `<leader>pf` | Switch focus |
| `<leader>ps` | Open popup in split |
| `<leader>pv` | Open popup in vsplit |
| `<leader>po` | Open in original window |

---

## Buffer Management

### Snacks
| Key | Description |
|-----|-------------|
| `<leader>bd` | Delete buffer |
| `<leader>bo` | Delete other buffers |

### Navigation
| Key | Description |
|-----|-------------|
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<leader>x` | Close buffer |

### Auto-close
- **hbac.nvim** automatically closes unused buffers (threshold: 10)

---

## Diagnostics

### Trouble.nvim
| Key | Description |
|-----|-------------|
| `<leader>xx` | All diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `<leader>xs` | Document symbols |
| `<leader>xl` | LSP definitions |
| `<leader>xt` | Todo list |
| `]t` / `[t` | Next/prev todo |

### Standard
| Key | Description |
|-----|-------------|
| `[d` / `]d` | Previous/next diagnostic |
| `<leader>ld` | Show diagnostic float |

---

## Toggle Options

| Key | Description |
|-----|-------------|
| `<leader>us` | Toggle spelling |
| `<leader>uw` | Toggle wrap |
| `<leader>ud` | Toggle diagnostics |
| `<leader>uh` | Toggle inlay hints |

---

## Terminal & Escape

### better-escape.nvim
- `jk` or `jj` exits insert mode without delay
- Works in terminal mode (`<C-\><C-n>` replacement)

### Terminal
| Key | Description |
|-----|-------------|
| `<C-x>` | Exit terminal mode |

---

## LSP Configuration

### Supported Languages
- **Rust:** rust-analyzer with clippy
- **Go:** gopls with gofumpt
- **TypeScript/JavaScript:** ts_ls with inlay hints
- **Python:** pylsp
- **Lua:** lua_ls (Neovim API aware)
- **JSON/YAML:** with SchemaStore support
- **Terraform:** terraform-ls
- **Bash:** bashls with shellcheck

### LSP Keymaps
| Key | Description |
|-----|-------------|
| `gD` | Go to declaration |
| `gd` | Go to definition |
| `gi` | Go to implementation |
| `gr` | Show references |
| `K` | Hover info |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>fm` | Format file |

---

## Quick Reference

### Most Used Keymaps
```
<leader><leader> - Smart picker (best default!)
<leader>gg       - LazyGit
<leader>pd       - Peek definition
s                - Flash jump
-                - Oil file explorer
<leader>xx       - Diagnostics
<leader>aa       - Avante ask
jk               - Exit insert mode
```

### Commands
```
:Lazy           - Plugin manager
:Mason          - LSP package manager
:Telescope      - Fuzzy finder
:Oil            - File manager
:Trouble        - Diagnostics panel
:MCPHub         - MCP servers
:Noice          - Message history
```

---

## Troubleshooting

### noice.nvim issues
```vim
:Noice          " Show message history
:Noice dismiss  " Dismiss notifications
```

### incline.nvim not showing
```vim
:checkhealth incline
```

### LazyGit not opening files in nvim
- Ensure `editPreset = "nvim-remote"` is set in Snacks config
- Check if nvim-remote is working: `:echo v:servername`

---

**Maintained by:** nwiizo
**AI Assistant:** Claude (Anthropic)
