# CLAUDE.md - Neovim Configuration Guide

This file provides guidance to Claude Code and AI assistants when working with this Neovim configuration.

## Overview

This is a **NvChad v2.5-based Neovim configuration** optimized for:
- Rust, Go, TypeScript, Python development
- Multiple AI assistant integrations
- 2025 best practices for navigation and productivity

**Last Updated:** 2025-12-14
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

### Recommendation

```
Daily workflow:
1. Copilot → inline completions (automatic)
2. CopilotChat → quick questions
3. Avante → complex refactoring

Advanced:
4. Cody → codebase-wide search
5. claude-code → terminal integration
```

---

## 2025 Essential Plugins

### Navigation & Search
| Plugin | Key | Description |
|--------|-----|-------------|
| **Telescope** | `<leader>ff` | Find files |
| | `<leader>fg` | Live grep |
| | `<leader>fb` | Buffers |
| | `<C-p>` | Quick file find |
| **oil.nvim** | `-` | File explorer (buffer-style) |
| | `<leader>e` | Open explorer |
| **flash.nvim** | `s` | Jump to any character |
| | `S` | Treesitter selection |

### Diagnostics & Git
| Plugin | Key | Description |
|--------|-----|-------------|
| **trouble.nvim** | `<leader>xx` | All diagnostics |
| | `<leader>xX` | Buffer diagnostics |
| | `<leader>xs` | Document symbols |
| **diffview.nvim** | `<leader>gd` | Git diff |
| | `<leader>gh` | File history |
| **todo-comments** | `<leader>xt` | Todo list |
| | `]t` / `[t` | Next/prev todo |

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

### Adding a New LSP

1. Add to `lua/configs/lspconfig.lua`:
```lua
local servers = {
  -- existing servers...
  "new_server",
}
```

2. Add custom config if needed:
```lua
local custom_configs = {
  new_server = {
    settings = { ... }
  },
}
```

3. Add to Mason in `lua/plugins/init.lua`:
```lua
ensure_installed = {
  "new-server-name",
}
```

---

## Key Principles

### DO
- Use lazy loading (`event`, `cmd`, `keys`) for plugins
- Prefer `opts = {}` over `config = function()` when possible
- Test changes with `:checkhealth`
- Keep LSP configs in `configs/lspconfig.lua`

### DON'T
- Don't conflict with NvChad default keymaps
- Don't add plugins without lazy-loading
- Don't modify `lua/core/` (NvChad managed)

---

## Troubleshooting

### Plugin not loading
```vim
:Lazy
" Check if plugin is installed and loaded
```

### LSP not working
```vim
:LspInfo
:Mason
" Install missing servers
```

### Copilot issues
```vim
:Copilot status
:Copilot auth
```

### Telescope errors
```bash
# Rebuild fzf-native
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
make
```

---

## Performance Tips

1. **Lazy load everything** - Use `event = "VeryLazy"` for non-critical plugins
2. **Use treesitter wisely** - Only install needed parsers
3. **Profile startup** - `:Lazy profile`

---

## Quick Reference

### Most Used Keymaps
```
<leader>ff  - Find files
<leader>fg  - Live grep
<leader>fb  - Buffers
-           - Oil file explorer
s           - Flash jump
<leader>xx  - Diagnostics
<leader>gd  - Git diff
<leader>aa  - Avante ask
<leader>cc  - Copilot chat
```

### Commands
```
:Telescope          - Fuzzy finder
:Oil                - File manager
:Trouble            - Diagnostics panel
:DiffviewOpen       - Git diff view
:Mason              - Package manager
:Lazy               - Plugin manager
:MCPHub             - MCP servers
```

---

**Maintained by:** nwiizo
**AI Assistant:** Claude (Anthropic)
