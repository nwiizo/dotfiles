# CLAUDE.md - Neovim Configuration Guide

This file provides guidance to Claude Code and AI assistants when working with this Neovim configuration.

## Overview

This is a **NvChad v3.0-based Neovim configuration** optimized for:
- Rust, Go, TypeScript, Python development
- AI-assisted coding workflow
- 2026 minimal UI workflow (statusline-less)

**Last Updated:** 2026-01
**Base:** NvChad v3.0 with lazy.nvim
**Theme:** aquarium
**Requirements:** Neovim 0.11+

---

## Directory Structure

```
nvim/
├── init.lua              # Entry point
├── lazy-lock.json        # Plugin version lock
├── .stylua.toml          # Lua formatter config
├── CLAUDE.md             # This file
└── lua/
    ├── chadrc.lua        # NvChad theme settings
    ├── mappings.lua      # Custom keymaps
    ├── options.lua       # Vim options
    ├── configs/
    │   ├── lazy.lua      # lazy.nvim settings
    │   ├── lspconfig.lua # LSP server configurations
    │   └── conform.lua   # Formatter settings
    └── plugins/
        ├── init.lua      # Plugin loader (merges all modules)
        ├── ui.lua        # UI plugins
        ├── navigation.lua # Navigation plugins
        ├── git.lua       # Git plugins
        ├── diagnostics.lua # Diagnostic plugins
        ├── lsp.lua       # LSP plugins
        ├── ai.lua        # AI plugins
        ├── completion.lua # Completion plugins
        └── lang.lua      # Language-specific plugins
```

---

## 2026 Minimal UI Architecture

This configuration follows a statusline-less workflow for maximum editing space.

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

## AI Plugin Strategy (2026)

This configuration includes **4 AI tools**:

### Primary: GitHub Copilot + CopilotChat
- **Use for:** Daily coding, inline completions, quick questions
- **Keymaps:** Automatic completions, `<leader>ao` for chat
- **CopilotChat Model:** claude-sonnet-4

### Secondary: Avante.nvim
- **Use for:** Complex refactoring, code generation with context
- **Model:** claude-sonnet-4
- **Keymaps:**
  - `<leader>aa` - Ask AI about current code
  - `<leader>ax` - Edit code with AI
  - `<leader>ar` - Refresh response
- **Features:** Cursor-like IDE experience

### Claude Code Integration
- **Plugin:** claudecode.nvim
- **Use for:** Claude Code terminal integration
- **Keymaps:**
  - `<leader>cc` - Toggle Claude Code
  - `<leader>cf` - Focus Claude Code

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

#### Basic Operations
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

#### Inside Diffview
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

#### Conflict Resolution
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

| Language | LSP | Formatter |
|----------|-----|-----------|
| Rust | rust-analyzer | rustfmt |
| Go | gopls | gofmt, goimports, gofumpt |
| TypeScript | ts_ls, deno | prettier, deno_fmt |
| Python | pyright | black, isort |
| Lua | lua_ls | stylua |
| Terraform | terraform-ls | terraform_fmt |
| Bash | bashls | shfmt |

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

## Plugin Modules

### ui.lua
- incline.nvim, modes.nvim, noice.nvim, nvim-notify
- vimade, better-escape.nvim, which-key.nvim, indent-blankline.nvim

### navigation.lua
- Snacks.nvim, telescope.nvim, oil.nvim
- flash.nvim, overlook.nvim, hbac.nvim

### git.lua
- gitsigns.nvim, diffview.nvim

### diagnostics.lua
- trouble.nvim, todo-comments.nvim

### lsp.lua
- nvim-lspconfig, mason.nvim, conform.nvim
- nvim-treesitter, schemastore.nvim

### ai.lua
- copilot.lua, copilot-cmp, CopilotChat.nvim
- avante.nvim, claudecode.nvim

### completion.lua
- nvim-cmp, cmp-nvim-lsp, cmp-buffer, cmp-path
- LuaSnip, lspkind.nvim

### lang.lua
- rustaceanvim, crates.nvim

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
