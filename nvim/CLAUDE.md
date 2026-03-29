# CLAUDE.md - Neovim Configuration Guide

LazyVimベースのNeovim設定。Rust/Go/TypeScript/Python開発 + AI支援コーディング + 2026 Minimal UI。

**Base:** LazyVim | **Theme:** catppuccin mocha | **Completion:** blink.cmp | **Requirements:** Neovim 0.11+

## Directory Structure

```
nvim/lua/
├── config/          # Neovim本体の設定 (options, keymaps, autocmds, lazy bootstrap)
└── plugins/         # プラグイン定義 (LazyVim override + カスタム)
    ├── disabled.lua     # lualine, bufferline, mini.surround, mini.pairs を無効化
    ├── colorscheme.lua  # catppuccin mocha
    ├── ui.lua           # incline, modes, vimade, better-escape, noice, which-key, nvim-surround, mini.ai, nvim-autopairs
    ├── navigation.lua   # Snacks, telescope, oil, flash, overlook, hbac
    ├── git.lua          # gitsigns, diffview
    ├── diagnostics.lua  # trouble, todo-comments
    ├── lsp.lua          # lspconfig, conform, mason, treesitter, schemastore
    ├── completion.lua   # blink.cmp
    ├── coding.lua       # yanky
    ├── ai.lua           # copilot-chat, avante, codecompanion, claudecode
    └── lang.lua         # rustaceanvim, crates, neotest, dap, cargo.nvim, marp.nvim
```

## Key Architecture Decisions

- **No statusline**: lualine disabled, incline.nvim floating at bottom-right
- **No bufferline**: bufferline disabled, Snacks picker for buffer selection
- **No mode text**: modes.nvim colors cursorline by mode
- **No cmdline**: cmdheight=0, noice.nvim centered popup
- **blink.cmp**: LazyVim default completion, copilot source via extras
- **LazyVim Extras**: 言語サポートはExtrasで管理 (lang.rust, lang.go, etc.)

## Plugin Override Pattern

LazyVim管理プラグインは `opts` テーブルのみ返す（LazyVimデフォルトにマージされる）。
カスタムプラグインは通常のlazy.nvimスペックを返す。

## Claude Code Keymaps (`<leader>c` prefix)

`<leader>cf` → `<leader>cF`, `<leader>cr` → `<leader>cR`, `<leader>ca` → `<leader>cA`
（LazyVimの `<leader>cf` format, `<leader>cr` rename, `<leader>ca` code action との衝突回避）
