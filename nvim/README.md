# Neovim Configuration

NvChad v3.0ベースのNeovim設定。Rust、Go、TypeScript、Python開発とAI支援コーディングに最適化。

**2026 Minimal UI**: statusline-less ワークフローで編集領域を最大化。

## 概要

- **ベース**: NvChad v3.0
- **テーマ**: aquarium
- **要件**: Neovim 0.11+
- **UI哲学**: 最小限のUI、最大限の編集領域

## 2026 Minimal UI アーキテクチャ

statusline/tabuflineを廃止し、必要な情報のみfloating windowで表示。

### UIコンポーネント

| コンポーネント | プラグイン | 役割 |
|---------------|-----------|------|
| ファイル情報 | incline.nvim | 右下floating statusline |
| モード表示 | modes.nvim | 現在行ハイライト色でモード表示 |
| コマンドライン | noice.nvim | floating cmdline (cmdheight=0) |
| バッファ薄暗化 | vimade | 非アクティブバッファをdim |
| コードピーク | overlook.nvim | LSP定義をstackable popup表示 |
| ファイル選択 | Snacks.nvim | smart pickerでbufferline代替 |

### incline.nvim 表示内容

- ファイルアイコン（filetype色）
- ファイル名（汎用名は親ディレクトリも表示: `plugins/init.lua`）
- 未保存マーク（オレンジの丸）
- 診断数（エラー/警告）
- 非アクティブ時は薄く表示

### modes.nvim カラー

| モード | 色 |
|--------|-----|
| Insert | Cyan (#78ccc5) |
| Visual | Purple (#9745be) |
| Copy | Yellow (#f5c359) |
| Delete | Red (#c75c6a) |

## 機能

### AI統合

| プラグイン | 用途 | モデル |
|-----------|------|--------|
| GitHub Copilot | コード補完 | - |
| CopilotChat | AIチャット | claude-sonnet-4 |
| avante.nvim | Cursor風IDE機能 | claude-sonnet-4 |
| claudecode.nvim | Claude Code統合 | - |

### 言語サポート

| 言語 | LSP | フォーマッター |
|------|-----|----------------|
| Rust | rust-analyzer | rustfmt |
| Go | gopls | gofmt, goimports, gofumpt |
| TypeScript | ts_ls, deno | prettier, deno_fmt |
| Python | pyright | black, isort |
| Lua | lua_ls | stylua |
| Terraform | terraform-ls | terraform_fmt |
| Bash | bashls | shfmt |

## ディレクトリ構成

```
nvim/
├── init.lua              # エントリポイント
├── lazy-lock.json        # プラグインバージョン
├── .stylua.toml          # Luaフォーマッター設定
├── CLAUDE.md             # AI向けドキュメント
└── lua/
    ├── chadrc.lua        # NvChadテーマ設定
    ├── mappings.lua      # カスタムキーマップ
    ├── options.lua       # Vimオプション
    ├── configs/
    │   ├── lazy.lua      # lazy.nvim設定
    │   ├── lspconfig.lua # LSPサーバー設定
    │   └── conform.lua   # フォーマッター設定
    └── plugins/
        ├── init.lua      # プラグインローダー
        ├── ui.lua        # UI系（incline, modes, noice, notify, vimade, which-key）
        ├── navigation.lua # ナビゲーション（snacks, telescope, oil, flash, overlook, hbac）
        ├── git.lua       # Git（gitsigns, diffview）
        ├── diagnostics.lua # 診断（trouble, todo-comments）
        ├── lsp.lua       # LSP（conform, lspconfig, mason, treesitter）
        ├── ai.lua        # AI（copilot, copilot-chat, avante, claudecode）
        ├── completion.lua # 補完（nvim-cmp）
        └── lang.lua      # 言語固有（rustaceanvim, crates）
```

## インストール

```bash
# 既存設定をバックアップ
mv ~/.config/nvim ~/.config/nvim.bak

# シンボリックリンク作成
ln -sf ~/ghq/github.com/nwiizo/dotfiles/nvim ~/.config/nvim

# Neovim起動（プラグイン自動インストール）
nvim

# プラグイン同期
:Lazy sync
```

## キーマップ

### 最重要キーマップ

| キー | 説明 |
|------|------|
| `<leader><leader>` | Smart Picker（ファイル+バッファ+最近使用） |
| `<leader>gg` | LazyGit（ファイルは現在のnvimで開く） |
| `<leader>pd` | Peek Definition（floating popup） |
| `s` | Flash jump（任意の文字へジャンプ） |
| `-` | Oil file explorer |
| `jk` / `jj` | ESC（遅延なし、ターミナルモードでも有効） |

### 基本操作

| キー | 説明 |
|------|------|
| `;` | コマンドモード |
| `<C-s>` | 保存 |
| `<Esc>` | 検索ハイライト消去 |

### Snacks.nvim Picker

| キー | 説明 |
|------|------|
| `<leader><leader>` | Smart Picker（メイン） |
| `<leader>sf` | ファイル検索 |
| `<leader>sg` | Grep検索 |
| `<leader>sb` | バッファ一覧 |
| `<leader>sr` | 最近使用したファイル |
| `<leader>sc` | コマンド |
| `<leader>sh` | ヘルプページ |
| `<leader>sk` | キーマップ |
| `<leader>sd` | 診断一覧 |
| `<leader>ss` | LSPシンボル |

### Telescope（サブ）

| キー | 説明 |
|------|------|
| `<leader>ff` | ファイル検索 |
| `<leader>fg` | Live Grep |
| `<leader>fb` | バッファ |
| `<C-p>` | クイックファイル検索 |

### Git統合

#### LazyGit (Snacks.nvim)

| キー | 説明 |
|------|------|
| `<leader>gg` | LazyGit（ファイルは現在のnvimで開く） |
| `<leader>gl` | LazyGit Log |
| `<leader>gf` | ファイル履歴（LazyGit） |

#### Diffview (Git Diff)

| キー | 説明 |
|------|------|
| `<leader>gd` | Working tree diff |
| `<leader>gD` | 前のコミットとのdiff |
| `<leader>gs` | ステージ済み変更 |
| `<leader>gm` | mainブランチとの比較 |
| `<leader>gM` | masterブランチとの比較 |
| `<leader>gh` | 現在ファイルの履歴 |
| `<leader>gH` | ブランチ全体の履歴 |
| `<leader>gq` | Diffview閉じる |
| `<leader>gt` | ファイルパネル切り替え |

#### Diffview内操作

| キー | 説明 |
|------|------|
| `<tab>` / `<s-tab>` | 次/前のファイル |
| `gf` | ファイルを開く |
| `-` / `s` | ステージ/アンステージ |
| `S` | 全てステージ |
| `U` | 全てアンステージ |
| `X` | 変更を復元 |
| `L` | コミットログを開く |
| `g?` | ヘルプ表示 |

#### コンフリクト解決

| キー | 説明 |
|------|------|
| `[x` / `]x` | 前/次のコンフリクト |
| `<leader>co` | oursを選択 |
| `<leader>ct` | theirsを選択 |
| `<leader>cb` | baseを選択 |
| `<leader>ca` | 全て選択 |
| `dx` | コンフリクト削除 |

#### Gitsigns

| キー | 説明 |
|------|------|
| `<leader>gp` | Hunkプレビュー |
| `<leader>gb` | Blame表示 |
| `[c` / `]c` | 前/次のhunk |

### コードピーク（overlook.nvim）

| キー | 説明 |
|------|------|
| `<leader>pd` | 定義をピーク（floating popup） |
| `<leader>pc` | 全popupを閉じる |
| `<leader>pu` | 最後のpopupを復元 |
| `<leader>pU` | 全popupを復元 |
| `<leader>pf` | フォーカス切り替え |
| `<leader>ps` | popupをsplitで開く |
| `<leader>pv` | popupをvsplitで開く |
| `<leader>po` | 元のウィンドウで開く |

### バッファ管理

| キー | 説明 |
|------|------|
| `<leader>bd` | バッファ削除 |
| `<leader>bo` | 他のバッファを削除 |
| `<S-h>` / `<S-l>` | 前/次のバッファ |
| `<leader>x` | バッファを閉じる |

### ナビゲーション

| キー | 説明 |
|------|------|
| `<C-d>` / `<C-u>` | 半ページスクロール（中央維持） |
| `<C-h/j/k/l>` | ウィンドウ間移動 |
| `s` | Flash jump |
| `S` | Flash Treesitter選択 |

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

### 診断

| キー | 説明 |
|------|------|
| `<leader>xx` | 全診断（Trouble） |
| `<leader>xX` | バッファ診断 |
| `<leader>xs` | ドキュメントシンボル |
| `<leader>xt` | TODO一覧 |
| `[d` / `]d` | 前/次の診断 |
| `[t` / `]t` | 前/次のTODO |
| `<leader>ld` | 診断詳細表示 |

### トグル

| キー | 説明 |
|------|------|
| `<leader>us` | スペルチェック |
| `<leader>uw` | 折り返し |
| `<leader>ud` | 診断表示 |
| `<leader>uh` | インレイヒント |

### AI機能

| キー | 説明 |
|------|------|
| `<leader>aa` | AI質問 (avante) |
| `<leader>ax` | AIでコード編集 (avante) |
| `<leader>ao` | CopilotChat開く |
| `<leader>ae` | コード説明 |
| `<leader>af` | コード修正 |
| `<leader>at` | テスト生成 |
| `<leader>cc` | Claude Codeトグル |
| `<leader>cf` | Claude Codeフォーカス |

### ビジュアルモード

| キー | 説明 |
|------|------|
| `J` / `K` | 行を下/上に移動 |
| `<leader>p` | ペースト（レジスタ保持） |
| `<leader>d` | 削除（レジスタなし） |

## オプション設定

主な設定（`lua/options.lua`）:

- `cmdheight = 0` - コマンドライン非表示（noice.nvimが代替）
- `laststatus = 0` - statusline非表示（incline.nvimが代替）
- `showmode = false` - モード表示非表示（modes.nvimが代替）
- 相対行番号
- スクロールオフセット: 8行
- タブ幅: 2スペース
- システムクリップボード連携
- 永続的undo
- スワップファイル無効

## プラグイン一覧

### UI (ui.lua)

| プラグイン | 説明 |
|-----------|------|
| incline.nvim | floating statusline |
| modes.nvim | cursorline色でモード表示 |
| noice.nvim | floating cmdline/messages |
| nvim-notify | 通知UI |
| vimade | 非アクティブバッファdim |
| better-escape.nvim | jk/jjで遅延なしエスケープ |
| which-key.nvim | キーマップヒント |
| indent-blankline.nvim | インデントガイド |

### ナビゲーション (navigation.lua)

| プラグイン | 説明 |
|-----------|------|
| Snacks.nvim | smart picker, lazygit, bufdelete, terminal |
| telescope.nvim | fuzzy finder |
| oil.nvim | ファイルマネージャ |
| flash.nvim | 高速ジャンプ |
| overlook.nvim | コードピーク |
| hbac.nvim | 未使用バッファ自動クローズ |

### Git (git.lua)

| プラグイン | 説明 |
|-----------|------|
| gitsigns.nvim | Git signs, hunk操作 |
| diffview.nvim | Git diff/履歴, コンフリクト解決 |

### 診断 (diagnostics.lua)

| プラグイン | 説明 |
|-----------|------|
| trouble.nvim | 診断パネル |
| todo-comments.nvim | TODO/FIXME/NOTE |

### LSP (lsp.lua)

| プラグイン | 説明 |
|-----------|------|
| nvim-lspconfig | LSP設定 |
| mason.nvim | LSPインストーラー |
| conform.nvim | フォーマッター |
| nvim-treesitter | シンタックスハイライト |
| schemastore.nvim | JSON/YAMLスキーマ |

### AI (ai.lua)

| プラグイン | 説明 |
|-----------|------|
| copilot.lua | GitHub Copilot |
| copilot-cmp | Copilot補完ソース |
| CopilotChat.nvim | AIチャット |
| avante.nvim | Cursor風AI編集 |
| claudecode.nvim | Claude Code統合 |

### 補完 (completion.lua)

| プラグイン | 説明 |
|-----------|------|
| nvim-cmp | 補完エンジン |
| cmp-nvim-lsp | LSP補完ソース |
| cmp-buffer | バッファ補完 |
| cmp-path | パス補完 |
| LuaSnip | スニペット |
| lspkind.nvim | 補完アイコン |

### 言語固有 (lang.lua)

| プラグイン | 説明 |
|-----------|------|
| rustaceanvim | Rust強化 |
| crates.nvim | Cargo.toml管理 |

## メンテナンス

```vim
" プラグイン更新
:Lazy sync

" Masonパッケージ更新
:Mason

" ヘルスチェック
:checkhealth

" メッセージ履歴
:Noice

" 通知消去
:Noice dismiss
```

## トラブルシューティング

### noice.nvim関連

```vim
:Noice          " メッセージ履歴表示
:Noice dismiss  " 通知消去
```

### incline.nvimが表示されない

```vim
:checkhealth incline
```

### LazyGitでファイルがnvimで開かない

- `editPreset = "nvim-remote"`が設定されているか確認
- `:echo v:servername`でnvim-remoteが動作しているか確認

## 要件

- Neovim 0.11+
- Node.js (Copilot, Mason)
- Rust toolchain (rust-analyzer)
- Go toolchain (gopls)
- lazygit (LazyGit統合用)
