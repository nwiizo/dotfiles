# Neovim Configuration

NvChad v2.5ベースのNeovim設定。Rust、Go、TypeScript、Python開発とAI支援コーディングに最適化。

## 概要

- **ベース**: NvChad v2.5
- **テーマ**: bearded-arc
- **要件**: Neovim 0.11+

## 機能

### AI統合

| プラグイン | 用途 | モデル |
|-----------|------|--------|
| GitHub Copilot | コード補完 | - |
| CopilotChat | AIチャット | claude-opus-4 |
| avante.nvim | Cursor風IDE機能 | claude-sonnet-4 |
| Sourcegraph Cody | コードインテリジェンス | - |
| codecompanion.nvim | AIチャット | Copilot |
| claude-code.nvim | Claude Code統合 | - |

### 言語サポート

| 言語 | LSP | フォーマッター |
|------|-----|----------------|
| Rust | rust-analyzer | rustfmt, clippy |
| Go | gopls | gofmt, goimports, gofumpt |
| TypeScript | deno, ts_ls | prettier |
| Python | pylsp | black, isort |
| Lua | lua_ls | stylua |
| Terraform | terraform-ls | terraform_fmt |
| Bash | bashls | shfmt |

## ディレクトリ構成

```
nvim/
├── init.lua              # エントリポイント
├── lazy-lock.json        # プラグインバージョン
├── .stylua.toml          # Luaフォーマッター設定
└── lua/
    ├── chadrc.lua        # NvChadテーマ設定
    ├── mappings.lua      # カスタムキーマップ
    ├── options.lua       # Vimオプション
    ├── configs/
    │   ├── lazy.lua      # lazy.nvim設定
    │   └── lspconfig.lua # LSPサーバー設定
    └── plugins/
        └── init.lua      # プラグイン定義
```

## インストール

```bash
# 既存設定をバックアップ
mv ~/.config/nvim ~/.config/nvim.bak

# シンボリックリンク作成
ln -sf ~/ghq/github.com/nwiizo/dotfiles/nvim ~/.config/nvim

# Neovim起動（プラグイン自動インストール）
nvim
```

## キーマップ

### 基本操作

| キー | 説明 |
|------|------|
| `;` | コマンドモード |
| `jk` | ESC（インサートモード） |
| `<C-s>` | 保存 |
| `<Esc>` | 検索ハイライト消去 |

### ナビゲーション

| キー | 説明 |
|------|------|
| `<C-d>` / `<C-u>` | 半ページスクロール（中央維持） |
| `<C-h/j/k/l>` | ウィンドウ間移動 |
| `<S-h>` / `<S-l>` | 前/次のバッファ |
| `<leader>x` | バッファを閉じる |

### LSP

| キー | 説明 |
|------|------|
| `gd` | 定義へジャンプ |
| `gD` | 宣言へジャンプ |
| `gi` | 実装へジャンプ |
| `gr` | 参照一覧 |
| `K` | ホバー情報 |
| `<leader>rn` | リネーム |
| `<leader>ca` | コードアクション |
| `<leader>fm` | フォーマット |

### 診断・Quickfix

| キー | 説明 |
|------|------|
| `[d` / `]d` | 前/次の診断 |
| `<leader>ld` | 診断詳細表示 |
| `<leader>q` | Quickfixを開く |
| `[q` / `]q` | 前/次のQuickfix項目 |

### Git (gitsigns)

| キー | 説明 |
|------|------|
| `[c` / `]c` | 前/次のhunk |
| `<leader>gp` | hunkプレビュー |
| `<leader>gb` | blame表示 |

### AI機能

| キー | 説明 |
|------|------|
| `<leader>aa` | AI質問 (avante) |
| `<leader>ae` | AIでコード編集 (avante) |
| `<leader>cc` | CodeCompanion Chat |
| `<leader>cl` | Claude Codeトグル |
| `<C-a>` | Cody補完（インサートモード） |

### ビジュアルモード

| キー | 説明 |
|------|------|
| `J` / `K` | 行を下/上に移動 |
| `<leader>p` | ペースト（レジスタ保持） |
| `<leader>d` | 削除（レジスタなし） |

## オプション設定

主な設定（`lua/options.lua`）:

- 相対行番号
- スクロールオフセット: 8行
- タブ幅: 2スペース
- システムクリップボード連携
- 永続的undo
- スワップファイル無効

## メンテナンス

```vim
" プラグイン更新
:Lazy sync

" Masonパッケージ更新
:Mason

" ヘルスチェック
:checkhealth
```

## 要件

- Neovim 0.11+ (vim.lsp.config API)
- Node.js (Copilot, Mason)
- Rust toolchain (rust-analyzer)
- Go toolchain (gopls)
