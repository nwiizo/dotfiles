# Neovim Configuration

LazyVimベースのNeovim設定。Rust、Go、TypeScript、Python開発とAI支援コーディングに最適化。

**2026 Minimal UI**: statusline-less ワークフローで編集領域を最大化。

## 概要

- **ベース**: [LazyVim](https://github.com/LazyVim/LazyVim)
- **テーマ**: catppuccin mocha
- **補完**: blink.cmp
- **要件**: Neovim 0.12+
- **UI哲学**: 最小限のUI、最大限の編集領域

## 読み方

| 目的 | セクション |
|---|---|
| ファイル配置を知りたい | カスタム設定の配置ルール、ディレクトリ構成 |
| UI 全体の考え方を知りたい | 2026 Minimal UI アーキテクチャ |
| 有効な LazyVim Extras を確認したい | 有効化している LazyVim Extras |
| AI / Git / Rust などのキーを調べたい | キーマップ |
| セットアップや検証をしたい | インストール、メンテナンス、要件 |

## カスタム設定の配置ルール

LazyVimでは設定ファイルの配置場所が役割で決まっている。

### lua/config/ -- Neovim本体の設定

| ファイル | 役割 | 読み込みタイミング |
|---|---|---|
| `lazy.lua` | lazy.nvim bootstrap + LazyVim Extras 一覧 | 起動時（最初） |
| `options.lua` | `vim.opt` の設定 | lazy.nvim起動前 |
| `keymaps.lua` | カスタムキーマップ | VeryLazy イベント |
| `autocmds.lua` | カスタム autocmd | VeryLazy イベント |

### lua/plugins/ -- プラグイン定義

このディレクトリ内の全 `.lua` ファイルが自動で読み込まれる。
ファイル名は自由だが、機能別に分割するのがベストプラクティス。

#### 設定パターン

**1. LazyVimが管理するプラグインをカスタマイズ（override）**

optsテーブルだけ返す。LazyVimのデフォルトにディープマージされる。

```lua
return {
  {
    "folke/noice.nvim",
    opts = {
      -- ここに書いた設定がLazyVimデフォルトにマージされる
      presets = { command_palette = true },
    },
  },
}
```

**2. LazyVimが管理するプラグインを無効化**

```lua
return {
  { "owner/plugin.nvim", enabled = false },
}
```

**3. 独自プラグインを追加**

通常のlazy.nvimスペックをそのまま返す。

```lua
return {
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    config = function()
      require("incline").setup({ ... })
    end,
  },
}
```

**4. optsテーブルではなく関数で完全制御**

LazyVimデフォルトを上書きしたい場合はopts関数を使う。

```lua
return {
  {
    "echasnovski/mini.ai",
    opts = function(_, opts)
      -- opts にはLazyVimデフォルトが入っている
      opts.n_lines = 500
      opts.custom_textobjects = { ... }
    end,
  },
}
```

### LazyVim Extras の有効化

`lua/config/lazy.lua` の `require("lazy").setup()` 内に import を追加する。

```lua
{ import = "lazyvim.plugins.extras.lang.rust" },
```

利用可能なExtras一覧: `:LazyExtras` コマンドで確認できる。

## 2026 Minimal UI アーキテクチャ

statusline/bufferlineを廃止し、必要な情報のみfloating windowで表示。

| コンポーネント | プラグイン | 役割 |
|---|---|---|
| ファイル情報 | incline.nvim | 右下 floating statusline |
| モード表示 | modes.nvim | 現在行ハイライト色でモード表示 |
| コマンドライン | noice.nvim | floating cmdline (cmdheight=0) |
| バッファ薄暗化 | vimade | 非アクティブバッファを dim |
| 関数コンテキスト | treesitter-context | 画面上部に関数ヘッダー固定 |
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
|---|---|
| Insert | Cyan (#78ccc5) |
| Visual | Purple (#9745be) |
| Copy | Yellow (#f5c359) |
| Delete | Red (#c75c6a) |

## ディレクトリ構成

```
nvim/
├── init.lua                    # エントリポイント: require("config.lazy")
├── .stylua.toml                # Luaフォーマッター設定
├── lazy-lock.json              # lazy.nvim plugin revision lockfile
├── lazyvim.json                # LazyVim metadata
└── lua/
    ├── config/
    │   ├── lazy.lua            # lazy.nvim bootstrap + Extras
    │   ├── options.lua         # Vimオプション
    │   ├── keymaps.lua         # カスタムキーマップ
    │   └── autocmds.lua        # カスタムautocmd
    └── plugins/
        ├── disabled.lua        # LazyVimデフォルト無効化
        ├── colorscheme.lua     # catppuccin mocha
        ├── ui.lua              # incline, modes, vimade, better-escape, noice override
        ├── navigation.lua      # Snacks override, telescope override, oil, overlook, hbac
        ├── git.lua             # gitsigns override, diffview, gitlinker
        ├── diagnostics.lua     # trouble override, todo-comments override, nvim-bqf
        ├── lsp.lua             # lspconfig, conform, mason, treesitter override
        ├── completion.lua      # blink.cmp override
        ├── coding.lua          # yanky, refactoring.nvim, treesj
        ├── ai.lua              # copilot-chat, avante, codecompanion, codex, claudecode
        └── lang.lua            # rustaceanvim, crates, neotest, dap, cargo, marp
```

## 有効化している LazyVim Extras

### 言語サポート

| Extra | 内容 |
|---|---|
| `lang.rust` | rustaceanvim + crates.nvim + neotest-rust + DAP |
| `lang.go` | gopls + neotest-golang |
| `lang.python` | pyright + ruff |
| `lang.typescript` | typescript-language-server |
| `lang.json` | jsonls + schemastore |
| `lang.yaml` | yamlls + schemastore |
| `lang.markdown` | markdownlint + render-markdown |
| `lang.terraform` | terraform-ls |
| `lang.zig` | zls |

### エディタ・コーディング

| Extra | 内容 |
|---|---|
| `editor.telescope` | Fuzzy finder |
| `editor.inc-rename` | LSPリネームのライブプレビュー |
| `editor.dial` | `<C-a>`/`<C-x>` でbool/演算子トグル |
| `coding.yanky` | ヤンク履歴 + サイクルペースト |
| `ui.treesitter-context` | 関数ヘッダー固定表示 |
| `dap.core` | デバッグアダプタプロトコル |
| `test.core` | テストランナーUI |

### AI

| Extra | 内容 |
|---|---|
| `ai.copilot` | GitHub Copilot |
| `ai.copilot-chat` | CopilotChat |

Custom AI integrations live in `lua/plugins/ai.lua`:

| Plugin | Role |
|---|---|
| `yetone/avante.nvim` | agentic editing through Codex ACP, Claude Code ACP, or Copilot |
| `nwiizo/codex.nvim` | Codex CLI side panel with terminal and app-server backends |
| `coder/claudecode.nvim` | Claude Code side-panel terminal |
| `nwiizo/signalbox.nvim` | Herdr persistent agents の attention board |
| `olimorris/codecompanion.nvim` | Vim-native Copilot-backed chat and inline actions |

Other custom integrations live in feature files under `lua/plugins/`:

| Plugin | Role |
|---|---|
| `stevearc/oil.nvim` | file explorer; configured directly because there is no active LazyVim `editor.oil` Extra |
| `WilliamHsieh/overlook.nvim` | stackable LSP definition popups |
| `axkirillov/hbac.nvim` | automatic cleanup for unused buffers |

## プラグイン選定メモ

既存の LazyVim / Snacks / Oil / Blink / Noice 構成と重複しないものだけを追加する。

| 追加 | 理由 |
|---|---|
| `kevinhwang91/nvim-bqf` | quickfix の preview / filter / split open を補強する。既存の Trouble や Snacks picker とは用途が違う |
| `linrongbin16/gitlinker.nvim` | 現在行や選択範囲の GitHub/GitLab permalink をコピー/ブラウザ表示できる。gitsigns/diffview にはない共有用途 |

## キーマップ

> `L` = LazyVim提供、`C` = カスタム、`P` = プラグイン提供

### 基本操作

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `;` | n | コマンドモード | C |
| `jk` / `jj` | i,c,t | ESC（遅延なし） | P better-escape |
| `<C-s>` | n,i,x | 保存 | L |
| `<Esc>` | n | 検索ハイライト消去 | L |

### ナビゲーション

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<C-d>` / `<C-u>` | n | 半ページスクロール（中央維持） | C |
| `n` / `N` | n | 検索結果移動（中央維持） | C |
| `<C-o>` | n | 前のジャンプ位置に戻る（gd等の後に） | Vim |
| `<C-i>` | n | 次のジャンプ位置に進む | Vim |
| `<C-h/j/k/l>` | n | ウィンドウ間移動 | L |
| `<S-h>` / `<S-l>` | n | 前/次のバッファ | L |
| `[b` / `]b` | n | 前/次のバッファ | L |
| `s` | n,x,o | Flash jump | P flash |
| `S` | n,x,o | Flash Treesitter選択 | P flash |
| `r` | o | Remote Flash | P flash |
| `%` | n | 対応するキーワードへジャンプ (if↔else, タグ等) | P matchup |
| `[w` / `]w` | n,x | 構文木: 前/次の兄弟ノード | P treewalker |
| `<A-h>` / `<A-l>` | n,x | 構文木: 親/子ノードへ移動 | P treewalker |
| `<A-S-j>` / `<A-S-k>` | n | 構文木: ノードを上下にスワップ | P treewalker |
| `<A-S-h>` / `<A-S-l>` | n | 構文木: ノードを左右にスワップ | P treewalker |

### ファイル・プロジェクト

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader><leader>` | n | Smart Picker（ファイル+バッファ+最近使用） | P Snacks |
| `<leader>/` | n | Grep（ルートディレクトリ） | L |
| `<leader>ff` | n | ファイル検索 | L |
| `<leader>fn` | n | 新規ファイル | L |
| `<C-p>` | n | ファイル検索 (Telescope) | C |
| `-` | n | Oil ファイルエクスプローラ | P oil |
| `<leader>e` | n | Oil ファイルエクスプローラ | P oil |

### Snacks Picker (`<leader>s` prefix)

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>sf` | n | ファイル検索 | P Snacks |
| `<leader>sg` | n | Grep | P Snacks |
| `<leader>sw` | n,x | カーソル下の単語をGrep | P Snacks |
| `<leader>sb` | n | バッファ一覧 | P Snacks |
| `<leader>sr` | n | 最近使用したファイル | P Snacks |
| `<leader>sc` | n | コマンド | P Snacks |
| `<leader>sh` | n | ヘルプページ | P Snacks |
| `<leader>sk` | n | キーマップ | P Snacks |
| `<leader>sd` | n | 診断一覧 | P Snacks |
| `<leader>ss` | n | LSPシンボル | P Snacks |
| `<leader>sR` | n | 最後のPickerを再開 | P Snacks |
| `<leader>sT` | n | TODO検索 | P todo-comments |
| `<leader>sy` | n | ヤンク履歴 | P yanky |

### バッファ管理

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>bd` | n | バッファ削除 | L Snacks |
| `<leader>bo` | n | 他のバッファを削除 | L Snacks |
| `<leader>bb` | n | バッファ切替 | L |

### LSP

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `gd` | n | 定義へジャンプ | L |
| `gr` | n | 参照一覧 | L |
| `gI` | n | 実装へジャンプ | L |
| `gy` | n | 型定義へジャンプ | L |
| `gD` | n | 宣言へジャンプ | L |
| `K` | n | ホバー情報 | L |
| `<leader>ca` | n,x | コードアクション | L |
| `<leader>cr` | n | リネーム（inc-rename ライブプレビュー） | L + Extra |
| `<leader>cf` | n,x | フォーマット | L |
| `<leader>lk` | n | シグネチャヘルプ | C |
| `<leader>ld` | n | 行の診断詳細 | C |
| `<leader>lq` | n | 診断をloclistへ | C |
| `<leader>lwa` | n | ワークスペースフォルダ追加 | C |
| `<leader>lwr` | n | ワークスペースフォルダ削除 | C |
| `<leader>lwl` | n | ワークスペースフォルダ一覧 | C |

### 診断

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `[d` / `]d` | n | 前/次の診断 | L |
| `<leader>xx` | n | 全診断 (Trouble) | P trouble |
| `<leader>xX` | n | バッファ診断 | P trouble |
| `<leader>xs` | n | ドキュメントシンボル | P trouble |
| `<leader>xl` | n | LSP定義 | P trouble |
| `<leader>xq` | n | Quickfix (Trouble) | P trouble |
| `<leader>xt` | n | TODO一覧 | P todo-comments |
| `[t` / `]t` | n | 前/次のTODO | P todo-comments |

### コードピーク (`<leader>p` prefix)

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>pd` | n | 定義をピーク（floating popup） | P overlook |
| `<leader>pc` | n | 全popupを閉じる | P overlook |
| `<leader>pu` | n | 最後のpopupを復元 | P overlook |
| `<leader>pU` | n | 全popupを復元 | P overlook |
| `<leader>pf` | n | フォーカス切替 | P overlook |
| `<leader>ps` | n | splitで開く | P overlook |
| `<leader>pv` | n | vsplitで開く | P overlook |
| `<leader>po` | n | 元のウィンドウで開く | P overlook |

### Git (`<leader>g` prefix)

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>gg` | n | LazyGit | P Snacks |
| `<leader>gl` | n | LazyGit Log | P Snacks |
| `<leader>gf` | n | LazyGit ファイル履歴 | P Snacks |
| `<leader>gd` | n | Working tree diff | P diffview |
| `<leader>gD` | n | 前のコミットとのdiff | P diffview |
| `<leader>gs` | n | ステージ済み変更 | P diffview |
| `<leader>gm` | n | mainブランチとの比較 | P diffview |
| `<leader>gM` | n | masterブランチとの比較 | P diffview |
| `<leader>gh` | n | 現在ファイルの履歴 | P diffview |
| `<leader>gH` | n | ブランチ全体の履歴 | P diffview |
| `<leader>gq` | n | Diffview閉じる | P diffview |
| `<leader>gt` | n | ファイルパネル切替 | P diffview |
| `<leader>gp` | n | Hunkプレビュー | P gitsigns |
| `<leader>gb` | n | Blame表示 | P gitsigns |
| `<leader>gB` | n | Blame切替 | P gitsigns |
| `<leader>gy` | n,v | 現在行/選択範囲のGit permalinkをコピー | P gitlinker |
| `<leader>gY` | n,v | 現在行/選択範囲のGit permalinkをブラウザで開く | P gitlinker |
| `]h` / `[h` | n | 次/前のhunk | L gitsigns |

### トグル (`<leader>u` prefix)

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>us` | n | スペルチェック | L |
| `<leader>uw` | n | 折り返し | L |
| `<leader>ul` | n | 行番号 | L |
| `<leader>ud` | n | 診断表示 | L |
| `<leader>uh` | n | インレイヒント | L |
| `<leader>uf` | n | 自動フォーマット | L |
| `<leader>ub` | n | ダークバックグラウンド | L |
| `<leader>ut` | n | Treesitterコンテキスト | P treesitter-context |
| `<leader>uz` | n | Zenモード | P Snacks |
| `<leader>uZ` | n | Zenズーム | P Snacks |

### ウィンドウ・スプリット

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>\|` | n | 縦分割 | L |
| `<leader>-` | n | 横分割 | L |
| `<leader>w=` | n | スプリット均等化 | C |
| `<leader>wm` | n | ウィンドウ最大化 | C |
| `<C-Up/Down/Left/Right>` | n | ウィンドウリサイズ | L |

### ビジュアルモード

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `J` / `K` | v | 行を下/上に移動 | C |
| `<A-j>` / `<A-k>` | n,i,v | 行を下/上に移動 | L |
| `<leader>P` | x | ペースト（レジスタ保持） | C |
| `<leader>D` | n,v | 削除（レジスタなし） | C |

### クリップボード・生産性

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>j` / `<leader>k` | n | 次/前のquickfix | C |
| `<leader>yp` | n | リポジトリ相対のファイルパスをコピー | C |
| `<leader>yl` | n,x | `path:line` / `path:start-end` をコピー | C |
| `zf` | qf | quickfix内をfzf風に絞り込み | P nvim-bqf |
| `<C-x>` / `<C-v>` | qf | quickfix項目を水平/垂直分割で開く | P nvim-bqf |
| `<C-a>` / `<C-x>` | n | インクリメント/デクリメント (dial拡張) | P dial |
| `[y` / `]y` | n | ペースト後にヤンク履歴サイクル | P yanky |

### ターミナル

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<c-/>` | n,t | ターミナルトグル | L |
| `<C-x>` | t | ターミナルモード終了 | C |

### AIエージェントによる外部編集

`autoread`と低頻度の`checktime`を利用し、Claude CodeやCodexが保存した
未変更bufferは自動的に再読込する。focus/buffer/terminalの切り替えと
normal modeのidle時だけ確認し、カーソル移動ごとのfilesystem確認は行わない。

Neovim側にも未保存の変更がある場合やfileが削除された場合は、内容を
自動上書きせず選択を求める。
エージェントへ場所を渡すときは`<leader>yl`で`path:line`形式をclipboardへ
コピーでき、visual selectionでは行範囲になる。

### セッション (`<leader>q` prefix)

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>qs` | n | セッション復元 | L persistence |
| `<leader>ql` | n | 最後のセッション復元 | L persistence |
| `<leader>qd` | n | セッション保存停止 | L persistence |
| `<leader>qq` | n | 全て閉じて終了 | L |

### AI (`<leader>a` prefix)

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>aa` | n | AI質問 (avante) | P avante |
| `<leader>aE` | n | AIでコード編集 (avante) | P avante |
| `<leader>aS` | n | Avante更新 | P avante |
| `<leader>aVc` | n | Avante provider: Codex ACP | P avante |
| `<leader>aVl` | n | Avante provider: Claude Code ACP | P avante |
| `<leader>aVp` | n | Avante provider: Copilot | P avante |
| `<leader>ax` | n | Codexを起動・フォーカス・非表示 | P codex.nvim |
| `<C-g>` | n,t | Herdr agent attention board / attachから戻る | P signalbox.nvim |
| `<leader>ao` | n | CopilotChat開く | P copilot-chat |
| `<leader>aq` | n | CopilotChat閉じる | P copilot-chat |
| `<leader>ar` | n | CopilotChatリセット | P copilot-chat |
| `<leader>am` | n | CopilotChatモデル選択 | P copilot-chat |
| `<leader>aP` | n | CopilotChatプロンプト一覧 | P copilot-chat |
| `<leader>ae` | n,v | コード説明 | P copilot-chat |
| `<leader>af` | n,v | コード修正 | P copilot-chat |
| `<leader>aO` | n,v | コード最適化 | P copilot-chat |
| `<leader>at` | n,v | テスト生成 | P copilot-chat |
| `<leader>ad` | n,v | ドキュメント生成 | P copilot-chat |
| `<leader>aR` | n,v | コードレビュー | P copilot-chat |
| `<leader>ag` | n | staged diffレビュー | P copilot-chat |
| `<leader>aG` | n | unstaged diffレビュー | P copilot-chat |
| `<leader>aW` | n | workspace tool chat | P copilot-chat |
| `<leader>aC` | n,v | CodeCompanion Chat | P codecompanion |
| `<leader>ai` | n,v | CodeCompanion Actions | P codecompanion |
| `<leader>ap` | n,v | CodeCompanion Inline | P codecompanion |
| `<leader>ac` | n | Claude Codeトグル | P claudecode |
| `<leader>aF` | n | Claude Codeフォーカス | P claudecode |
| `<leader>au` | n | Claude Code Resume | P claudecode |
| `<leader>aK` | n | Claude Code Continue | P claudecode |
| `<leader>aM` | n | Claudeモデル選択 | P claudecode |
| `<leader>ab` | n | 現在バッファをClaudeへ追加 | P claudecode |
| `<leader>as` | v | 選択範囲をClaudeへ送信 | P claudecode |
| `<leader>aT` | n | ツリーからファイル追加 | P claudecode |
| `<leader>ay` | n | Claude diff accept | P claudecode |
| `<leader>an` | n | Claude diff deny | P claudecode |

### Codelens

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>Cl` | n | Run Codelens | L (remapped) |

### Rust (`<leader>r` prefix, Rustファイルのみ)

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>ra` | n | Rustコードアクション | P rustaceanvim |
| `<leader>rd` | n | デバッグ可能一覧 | P rustaceanvim |
| `<leader>rr` | n | 実行可能一覧 | P rustaceanvim |
| `<leader>rR` | n | 前回の実行を再実行 | P rustaceanvim |
| `<leader>rt` | n | テスト可能一覧 | P rustaceanvim |
| `<leader>rT` | n | 前回のテストを再実行 | P rustaceanvim |
| `<leader>rm` | n | マクロ展開 | P rustaceanvim |
| `<leader>rc` | n | Cargo.tomlを開く | P rustaceanvim |
| `<leader>rp` | n | 親モジュール | P rustaceanvim |

### Crates (`<leader>rc` prefix, Cargo.tomlのみ)

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>rct` | n | Cratesトグル | P crates |
| `<leader>rcr` | n | Cratesリロード | P crates |
| `<leader>rcv` | n | バージョン一覧 | P crates |
| `<leader>rcf` | n | Feature一覧 | P crates |
| `<leader>rcd` | n | 依存関係一覧 | P crates |
| `<leader>rcu` | n,v | クレート更新 | P crates |
| `<leader>rcU` | n,v | クレートアップグレード | P crates |
| `<leader>rcA` | n | 全クレートアップグレード | P crates |
| `<leader>rcH` | n | ホームページを開く | P crates |
| `<leader>rcR` | n | リポジトリを開く | P crates |
| `<leader>rcD` | n | docs.rsを開く | P crates |
| `<leader>rcC` | n | crates.ioを開く | P crates |
| `<leader>rj` | n | 行結合 | P rustaceanvim |
| `<leader>rs` | n | 構造的検索置換 | P rustaceanvim |
| `<leader>re` | n | エラー説明 | P rustaceanvim |
| `<leader>rD` | n | 診断レンダリング | P rustaceanvim |
| `<leader>rv` | n | HIR表示 | P rustaceanvim |
| `<leader>rV` | n | MIR表示 | P rustaceanvim |
| `K` | n | Rustホバーアクション | P rustaceanvim |

### テスト (`<leader>T` prefix)

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>Tr` | n | 最寄りテスト実行 | P neotest |
| `<leader>Tf` | n | ファイルテスト実行 | P neotest |
| `<leader>Ts` | n | テストサマリー切替 | P neotest |
| `<leader>To` | n | テスト出力表示 | P neotest |
| `<leader>Tp` | n | 出力パネル切替 | P neotest |
| `<leader>Td` | n | 最寄りテストをデバッグ | P neotest |
| `[T` / `]T` | n | 前/次の失敗テスト | P neotest |

### デバッグ (`<leader>d` prefix)

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>db` | n | ブレークポイント切替 | P dap |
| `<leader>dB` | n | 条件付きブレークポイント | P dap |
| `<leader>dc` | n | Continue | P dap |
| `<leader>dC` | n | カーソルまで実行 | P dap |
| `<leader>di` | n | Step into | P dap |
| `<leader>do` | n | Step over | P dap |
| `<leader>dO` | n | Step out | P dap |
| `<leader>dp` | n | Pause | P dap |
| `<leader>dr` | n | REPL切替 | P dap |
| `<leader>dt` | n | Terminate | P dap |
| `<leader>du` | n | DAP UI切替 | P dap |
| `<leader>de` | n,v | Eval | P dap |

### リファクタリング (`<leader>R` prefix)

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>Rf` | n,x | Extract Function | P refactoring |
| `<leader>RF` | n,x | Extract Function to File | P refactoring |
| `<leader>Rv` | n,x | Extract Variable | P refactoring |
| `<leader>Ri` | n,x | Inline Variable | P refactoring |
| `<leader>Rp` | n | Debug Print Location | P refactoring |
| `<leader>RP` | n,x | Debug Print Variable | P refactoring |
| `<leader>Rc` | n | Debug Print 全削除 | P refactoring |
| `<leader>Rs` | n,x | Refactoring Selector | P refactoring |

## インストール

```bash
# 既存設定をバックアップ
mv ~/.config/nvim ~/.config/nvim.bak

# シンボリックリンク作成
cd ~/ghq/github.com/nwiizo/dotfiles
./scripts/link.sh

# Neovim起動（プラグイン自動インストール）
nvim

# lockfileの状態を再現
:Lazy restore
```

`lazy-lock.json` はlazy.nvim公式推奨どおりバージョン管理する。別マシンでは
`:Lazy restore` でlockfileのrevisionへ復元できる。`:Lazy update` による
revision更新は、関連する設定変更と一緒にレビュー・コミットする。

## メンテナンス

```vim
:Lazy update        " プラグインとlockfileを更新
:Lazy restore       " lockfileの状態へ復元
:Lazy sync          " install・clean・updateをまとめて実行
:Lazy health        " ヘルスチェック
:LazyExtras         " Extras一覧・管理
:Mason              " LSP/DAP/Linter管理
:checkhealth        " 全体ヘルスチェック
:Noice              " メッセージ履歴
```

## 要件

- Neovim 0.12+
- Node.js (Copilot, Mason)
- Rust toolchain (rust-analyzer)
- Go toolchain (gopls)
- lazygit (LazyGit統合用)
- ripgrep (Snacks picker, Telescope)
