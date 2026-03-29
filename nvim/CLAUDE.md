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
    ├── lsp.lua          # lspconfig, conform, mason, treesitter
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

## Claude Code Keymaps (`<leader>C` prefix)

`<leader>Cc` toggle, `<leader>Cf` focus, `<leader>Cr` resume, `<leader>CC` continue
（LazyVimの `<leader>c` = code group との衝突回避のため大文字 `C` prefix）

## LazyVim移行で得た知見（2026-03）

### Plugin Override の注意点

**`on_attach` は関数なのでディープマージされない。** LazyVimが設定した `on_attach` を保持するには:
```lua
opts = function(_, opts)
  local prev_on_attach = opts.server and opts.server.on_attach
  opts.server.on_attach = function(client, bufnr)
    if prev_on_attach then prev_on_attach(client, bufnr) end
    -- カスタムキーマップをここに追加
  end
  return opts
end
```
gitsigns, rustaceanvim 等 `on_attach` を持つプラグインは全てこのパターンが必要。
単純な `opts = { on_attach = function() ... end }` はLazyVimのキーマップ（gd, gr等）を破壊する。

**`default_settings` 等のテーブルも `vim.tbl_deep_extend` を使う:**
```lua
opts.server.default_settings = vim.tbl_deep_extend("force", opts.server.default_settings or {}, { ... })
```
直接代入するとLazyVim extrasの設定が消える。

### キーマップ衝突の解決パターン

LazyVimが使う主要prefix: `<leader>c` (code), `<leader>f` (find), `<leader>s` (search), `<leader>g` (git), `<leader>d` (debug/DAP), `<leader>x` (diagnostics), `<leader>b` (buffer), `<leader>u` (toggle), `<leader>q` (session)

衝突回避で採用した方式:
- Claude Code: `<leader>c` → `<leader>C`（大文字prefix）
- Crates.nvim: `<leader>c` → `<leader>rc`（Rust subgroup）
- Delete without yank: `<leader>d` → `<leader>D`（大文字）

### プラグインのGitHub org名変更（2025-2026）

LazyVimが追従済み。自分のspecでも新名を使うこと:
- `echasnovski/mini.*` → `nvim-mini/mini.*`
- `williamboman/mason.nvim` → `mason-org/mason.nvim`

### LazyVim Extras の存在確認

Extrasは頻繁に追加・削除される。存在しないextraを `import` するとエラーになる:
- `editor.oil` は存在しない → oil.nvimはカスタムプラグインとして自分で定義
- 確認方法: `ls ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/`

### LazyVimデフォルトの無効化

- **spell check**: `lazyvim_wrap_spell` augroup がmarkdown/textでspellを自動有効化する。日本語で大量の誤検知が出るため `vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")` で無効化
- **markdownlint**: `lang.markdown` extra が有効化する。`nvim-lint` の `linters_by_ft.markdown = {}` で無効化
- **dashboard**: Snacks の `dashboard = { enabled = false }` で無効化
- **format_on_save**: conform.nvim に直接 `format_on_save` を設定するとLazyVimの `<leader>uf` トグルが効かなくなる。LazyVim に任せること
- **nvim-notify**: Snacks.notifier と競合する。Snacks.notifier を使う場合は nvim-notify のスペックを削除

### modes.nvim API変更

`ignore_filetypes` → `ignore` にリネーム済み（2025年以降）

### デプロイ時の注意

- `~/.config/nvim` がsymlinkではなく独立gitリポジトリの場合がある。dotfilesの変更が反映されない原因
- `lazy-lock.json` に旧フレームワーク（NvChad等）のエントリが残るとプラグインが混在する。フレームワーク切替時は削除
- `~/.local/share/nvim/lazy/` に旧org名でcloneされたディレクトリが残る場合がある。org名変更後は該当ディレクトリを削除して再clone
- ネイティブライブラリを持つプラグイン（cargo.nvim等）は `build = "cargo build --release"` が必要
