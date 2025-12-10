# Neovim Configuration

**Version:** NvChad v2.5 based
**Last Updated:** 2025-12-09

## Overview

This is a Neovim configuration based on NvChad v2.5, optimized for:
- Rust development (rustaceanvim, crates.nvim, cargo.nvim)
- Go development (gopls, gofumpt)
- AI-assisted coding (Copilot, CopilotChat, avante.nvim, Cody)
- Infrastructure as Code (Terraform)

## Features

### AI Integration
- **GitHub Copilot** - Code completion
- **CopilotChat** - Chat with claude-opus-4
- **avante.nvim** - Cursor-like AI IDE features (claude-sonnet-4)
- **Sourcegraph Cody** - Code intelligence
- **codecompanion.nvim** - AI chat
- **claude-code.nvim** - Claude Code integration

### Language Support
- Rust (rust-analyzer, clippy, rustfmt)
- Go (gopls, goimports, gofumpt)
- TypeScript/JavaScript (deno, prettier)
- Python (pylsp, black, isort)
- Lua (lua_ls, stylua)
- Terraform (terraform-ls)
- Bash (bashls, shfmt, shellcheck)

### Key Plugins
- **conform.nvim** - Format on save
- **nvim-cmp** - Completion with AI sources
- **telescope.nvim** - Fuzzy finder
- **treesitter** - Syntax highlighting
- **gitsigns** - Git integration

## Directory Structure

```
nvim/
├── init.lua              # Entry point (NvChad bootstrap)
├── lazy-lock.json        # Plugin versions lock
├── .stylua.toml          # Lua formatter config
└── lua/
    ├── chadrc.lua        # NvChad theme config
    ├── mappings.lua      # Custom keymaps
    ├── options.lua       # Vim options
    ├── configs/
    │   ├── conform.lua   # Formatter config
    │   ├── lazy.lua      # Lazy.nvim config
    │   └── lspconfig.lua # LSP servers
    └── plugins/
        └── init.lua      # All plugin specs
```

## Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone dotfiles
ghq get nwiizo/dotfiles

# Create symlink
ln -sf ~/ghq/github.com/nwiizo/dotfiles/nvim ~/.config/nvim

# Start Neovim (plugins will install automatically)
nvim
```

## Key Mappings

### AI Features
| Key | Description |
|-----|-------------|
| `<leader>aa` | Ask AI about current code (avante) |
| `<leader>ae` | Edit code with AI (avante) |
| `<leader>cc` | Open CodeCompanion Chat |
| `<leader>cl` | Toggle Claude Code terminal |
| `<C-a>` | Trigger Cody completion (in insert mode) |

### General
| Key | Description |
|-----|-------------|
| `<leader>ff` | Find files |
| `<leader>fw` | Find word (grep) |
| `<leader>fb` | Find buffers |
| `<leader>e` | File explorer |

## Theme

Using `bearded-arc` theme. Change in `lua/chadrc.lua`:

```lua
M.ui = {
  theme = "bearded-arc",
}
```

## Local Customization

Create `lua/custom/` directory for machine-specific settings (gitignored).

## Requirements

- Neovim 0.11+ (for new vim.lsp.config API)
- Node.js (for Copilot, mason packages)
- Rust toolchain (for rust-analyzer, cargo.nvim)
- Go toolchain (for gopls)

## Maintenance

Update plugins:
```vim
:Lazy sync
```

Update Mason packages:
```vim
:Mason
```
