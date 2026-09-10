# CLAUDE.md - Neovim Configuration Guide

LazyVimベースのNeovim設定。Rust/Go/TypeScript/Python開発 + AI支援コーディング + 2026 Minimal UI。

**Base:** LazyVim | **Theme:** catppuccin mocha | **Completion:** blink.cmp | **Requirements:** Neovim 0.12+

`lazy-lock.json` はプラグインの再現性を保つためリポジトリ管理する。
`:Lazy update` で revision を更新し、`:Lazy restore` で lockfile の状態を
再現する。`:Lazy sync` は install・clean・update をまとめて実行する。
lockfile の変更は、関連するプラグイン設定と同じコミットに含める。

## Directory Structure

```
nvim/lua/
├── config/          # Neovim本体の設定 (options, keymaps, autocmds, lazy bootstrap)
└── plugins/         # プラグイン定義 (LazyVim override + カスタム)
    ├── disabled.lua     # lualine, bufferline, mini.surround, mini.pairs, neo-tree を無効化
    ├── colorscheme.lua  # catppuccin mocha
    ├── ui.lua           # incline, modes, vimade, better-escape, noice, which-key, nvim-surround, mini.ai, nvim-autopairs, vim-matchup
    ├── navigation.lua   # Snacks, fff, oil, flash, overlook, hbac, treewalker
    ├── git.lua          # gitsigns, codediff, diffview
    ├── diagnostics.lua  # trouble, todo-comments, nvim-bqf
    ├── lsp.lua          # lspconfig, conform, mason, treesitter
    ├── completion.lua   # blink.cmp
    ├── coding.lua       # yanky, refactoring.nvim, treesj
    ├── ai.lua           # copilot, copilot-chat, avante, render-markdown, signalbox, codex.nvim, claudecode
    └── lang.lua         # nvim-ts-autotag, rustaceanvim, crates, neotest, cargo.nvim, marp.nvim
```

## Key Architecture Decisions

- **No statusline**: lualine disabled, incline.nvim floating at bottom-right
- **No bufferline**: bufferline disabled, Snacks picker for buffer selection
- **No mode text**: modes.nvim colors cursorline by mode
- **No cmdline**: cmdheight=0, noice.nvim centered popup
- **blink.cmp**: LazyVim default completion. Copilot is inline only (`vim.g.ai_cmp = false` in options.lua), not a blink source
- **Picker**: LazyVim 既定の Snacks picker に統一（`editor.telescope` extra は使わない）
- **LazyVim Extras**: 言語サポートはExtrasで管理 (lang.rust, lang.go, etc.)

## Plugin Override Pattern

LazyVim管理プラグインは `opts` テーブルのみ返す（LazyVimデフォルトにマージされる）。
カスタムプラグインは通常のlazy.nvimスペックを返す。

## AI Keymaps (`<leader>a` prefix)

`<leader>ax` toggles Codex sidebar and `<leader>o*` holds the other Codex
actions (ask, edit, prompt, send, add, resume, review). Codex selection hints show
`<leader>oa` for Ask and `<leader>oe` for Edit; configure both through
`selection.keymaps`. Avante's selection hint is also shown so either integration
can be chosen from the same selection.
After sending, `<leader>om` opens next actions, `<leader>ou` composes a follow-up,
`<leader>od` reviews the session project's changes with CodeDiff, and `<leader>oh`
hides the panel without stopping it. The terminal winbar advertises buffer-local
`Alt-a` actions, `Alt-d` diff, and `Alt-q` hide. `<leader>oR` composes a review
request in the current conversation; submission remains explicit with Ctrl-S.
Avante uses `<leader>aa` for ask,
`<leader>aE` for edit, and `<leader>a1`/`<leader>a2`/`<leader>a3` to switch between Codex ACP,
Claude Code ACP, and Copilot providers. Claude Code uses `<leader>ac`,
`<leader>aF`, `<leader>au`, and `<leader>aK`.

LazyVim's `<leader>c` remains the code group. AI integrations stay under
`<leader>a`; codelens is available through `<leader>Cl`.

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

LazyVimが使う主要prefix: `<leader>c` (code), `<leader>f` (find), `<leader>s` (search), `<leader>g` (git), `<leader>gh` (hunks), `<leader>d` (debug/DAP), `<leader>x` (diagnostics), `<leader>b` (buffer), `<leader>u` (toggle), `<leader>q` (session), `<leader>t` (test), `<leader>l` (Lazy UI)

衝突回避で採用した方式:
- AI integrations: `<leader>a` group
- Codex sidebar: `<leader>ax`, overriding LazyVim CopilotChat reset there
- Avante edit: `<leader>aE` to leave `<leader>ax` for Codex
- Crates.nvim: `<leader>c` → `<leader>rc`（Rust subgroup）
- Delete without yank: `<leader>d` → `<leader>D`（大文字）
- Diffview file history: `<leader>gh` → `<leader>gF`（`<leader>gh` は gitsigns hunk group）
- neotest は LazyVim の `<leader>t` をそのまま使い、自前の `<leader>T` グループは置かない
- `<leader>l` は `:Lazy` なので LSP 用 prefix にしない（行診断は `<leader>cd`、シグネチャは `gK`）
- `<leader>` の後は 2 キーまでにする。空いている 1 文字目（`h`、`o` など）は積極的に使い、独自の 3 キーチェーンは作らない
- gitsigns の hunk 操作は 2 キーの `<leader>h*`（LazyVim の `<leader>gh*` も残る）
- Codex は `<leader>o*`、Claude Code と Avante、CopilotChat は `<leader>a*`
- crates.nvim は Cargo.toml バッファ限定なので `<leader>r*` を直接使う（.rs バッファの rustaceanvim キーと衝突しない）
- quickfix 移動は `]q` / `[q`、picker の再開は `<leader>sR`。単語置換の準備は `<leader>cw`
- CopilotChat の `<leader>aq`（Quick Chat）と `<leader>ap`（プロンプト）は LazyVim 既定のまま。閉じるのは窓内の `q`

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
- **行番号の強制 autocmd**: 不要。LazyVim 既定で number/relativenumber は有効で、Snacks の terminal/backdrop は自前で無効化する

### modes.nvim API変更

`ignore_filetypes` → `ignore` にリネーム済み（2025年以降）

### rust-analyzer の設定キー

`checkOnSave` は boolean で、clippy の指定は `check.command` / `check.extraArgs` に置く。
除外ディレクトリは `files.exclude`（`files.excludeDirs` は廃止）。
`rust-analyzer --print-config-schema` でキーの有無を確認できる。LazyVim の
`lang.rust` extra が cargo・procMacro・files.exclude を設定するので、自分の
`default_settings` には差分だけを書く。

### refactoring.nvim v2

Neovim 0.12+ と `lewis6991/async.nvim` が必須。旧 `refactor("...")` API と
Telescope extension は廃止済みなので、`extract_func()` などの操作別 API と
`select_refactor()` を使う。debug API は `require("refactoring.debug")` から呼ぶ。

### デプロイ時の注意

- `~/.config/nvim` がsymlinkではなく独立gitリポジトリの場合がある。dotfilesの変更が反映されない原因
- `lazy-lock.json` に旧フレームワーク（NvChad等）のエントリが残るとプラグインが混在する。フレームワーク切替時は削除
- `~/.local/share/nvim/lazy/` に旧org名でcloneされたディレクトリが残る場合がある。org名変更後は該当ディレクトリを削除して再clone
- ネイティブライブラリを持つプラグイン（cargo.nvim等）は `build = "cargo build --release"` が必要
