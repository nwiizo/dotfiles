# Neovim Configuration

LazyVimベースのNeovim設定。Rust、Go、TypeScript、Python開発とAI支援コーディングに最適化。

ステータスラインを省き、コードとエージェント用のターミナルに表示領域を使う。

## 概要

- **ベース**: [LazyVim](https://github.com/LazyVim/LazyVim)
- **テーマ**: catppuccin mocha
- **補完**: blink.cmp
- **要件**: Neovim 0.12+
- **UI哲学**: 最小限のUI、最大限の編集領域

## 読み方

| 目的 | セクション |
| --- | --- |
| ファイル配置を知りたい | カスタム設定の配置ルール、ディレクトリ構成 |
| UI 全体の考え方を知りたい | 画面構成 |
| 有効な LazyVim Extras を確認したい | 有効化している LazyVim Extras |
| AI / Git / Rust などのキーを調べたい | キーマップ |
| セットアップや検証をしたい | インストール、メンテナンス、要件 |

## カスタム設定の配置ルール

LazyVimでは設定ファイルの配置場所が役割で決まっている。

### lua/config/ -- Neovim本体の設定

| ファイル | 役割 | 読み込みタイミング |
| --- | --- | --- |
| `lazy.lua` | lazy.nvim bootstrap + LazyVim Extras 一覧 | 起動時（最初） |
| `options.lua` | `vim.opt` の設定 | lazy.nvim起動前 |
| `keymaps.lua` | カスタムキーマップ | VeryLazy イベント |
| `autocmds.lua` | カスタム autocmd | VeryLazy イベント |

### lua/plugins/ -- プラグイン定義

`lazy.lua` の `{ import = "plugins" }` が、機能別の定義を読み込む。通常は `opts = { ... }` で必要な値だけ指定し、LazyVimの設定にマージする。コールバックなどを扱う場合は `opts = function(_, opts)` で受け取った設定を変更する。新しいテーブルだけを返すと元の設定が置き換わるため、検索やキーマップの連携も失われる。既存の `on_attach` は呼び出しを引き継ぐ。無効化は `enabled = false` を使う。

詳細は [lazy.nvimの設定仕様](https://lazy.folke.io/spec#spec-setup) と [LazyVimのカスタマイズ](https://www.lazyvim.org/configuration/plugins) を参照。Neovim本体のオプションは `config/options.lua` に差分だけを置く。

### LazyVim Extras の有効化

`lua/config/lazy.lua` の `require("lazy").setup()` 内に import を追加する。

```lua
{ import = "lazyvim.plugins.extras.lang.rust" },
```

利用可能なExtras一覧: `:LazyExtras` コマンドで確認できる。

## 画面構成

statusline/bufferlineを廃止し、必要な情報のみfloating windowで表示。

| コンポーネント   | プラグイン         | 役割                           |
| ---------------- | ------------------ | ------------------------------ |
| ファイル情報     | incline.nvim       | 右下 floating statusline       |
| モード表示       | modes.nvim         | 現在行ハイライト色でモード表示 |
| コマンドライン   | noice.nvim         | floating cmdline (cmdheight=0) |
| バッファ薄暗化   | vimade             | 非アクティブバッファを dim     |
| 関数コンテキスト | treesitter-context | 画面上部に関数ヘッダー固定     |
| コードピーク     | overlook.nvim      | LSP定義をstackable popup表示   |
| ファイル選択     | Snacks.nvim        | smart pickerでbufferline代替   |

### incline.nvim 表示内容

- ファイルアイコン（filetype色）
- ファイル名（汎用名は親ディレクトリも表示: `plugins/init.lua`）
- 未保存マーク（オレンジの丸）
- 診断数（エラー/警告）
- 非アクティブ時は薄く表示

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
        ├── navigation.lua      # Snacks override, fff, oil, overlook, hbac
        ├── git.lua             # gitsigns override, codediff, diffview
        ├── diagnostics.lua     # trouble override, todo-comments override, nvim-bqf
        ├── lsp.lua             # lspconfig, conform, mason, treesitter override
        ├── completion.lua      # blink.cmp override
        ├── coding.lua          # yanky, refactoring.nvim, treesj
        ├── ai.lua              # copilot-chat, avante, codex, claudecode
        └── lang.lua            # rustaceanvim, crates, neotest, dap, cargo, marp
```

## 有効化している LazyVim Extras

### 言語サポート

| Extra             | 内容                                            |
| ----------------- | ----------------------------------------------- |
| `lang.rust`       | rustaceanvim + crates.nvim + neotest-rust + DAP |
| `lang.go`         | gopls + neotest-golang                          |
| `lang.python`     | pyright + ruff                                  |
| `lang.typescript` | typescript-language-server                      |
| `lang.json`       | jsonls + schemastore                            |
| `lang.yaml`       | yamlls + schemastore                            |
| `lang.markdown`   | markdownlint + render-markdown                  |
| `lang.terraform`  | terraform-ls                                    |
| `lang.zig`        | zls                                             |

Go の補完・定義ジャンプ・参照検索・整形・テスト・デバッグは [`lang.go` の公式設定](https://www.lazyvim.org/extras/lang/go)を使う。gopls・整形ツール・テストアダプターの既定値は個別設定にコピーせず、Extra の更新を引き継ぐ。gopls の設定を追加するときは、[現行版の設定一覧](https://go.dev/gopls/settings)で対応を確認する。

Rust のテストも `lang.rust` が用意する `rustaceanvim.neotest` を使う。別の `neotest-rust` アダプターは追加しない。

### エディタ・コーディング

| Extra                   | 内容                                |
| ----------------------- | ----------------------------------- |
| `editor.inc-rename`     | LSPリネームのライブプレビュー       |
| `editor.dial`           | `<C-a>`/`<C-x>` でbool/演算子トグル |
| `coding.yanky`          | ヤンク履歴 + サイクルペースト       |
| `ui.treesitter-context` | 関数ヘッダー固定表示                |
| `dap.core`              | デバッグアダプタプロトコル          |
| `test.core`             | テストランナーUI                    |

### AI

| Extra             | 内容           |
| ----------------- | -------------- |
| `ai.copilot`      | GitHub Copilot |
| `ai.copilot-chat` | CopilotChat    |

Custom AI integrations live in `lua/plugins/ai.lua`:

| Plugin | Role |
| --- | --- |
| `yetone/avante.nvim` | agentic editing through Codex ACP, Claude Code ACP, or Copilot |
| `nwiizo/codex.nvim` | Codex CLI side panel with terminal and app-server backends |
| `coder/claudecode.nvim` | Claude Code side-panel terminal |
| `nwiizo/signalbox.nvim` | Herdr persistent agents の attention board |

Other custom integrations live in feature files under `lua/plugins/`:

| Plugin | Role |
| --- | --- |
| `stevearc/oil.nvim` | file explorer; configured directly because there is no active LazyVim `editor.oil` Extra |
| `WilliamHsieh/overlook.nvim` | stackable LSP definition popups |
| `axkirillov/hbac.nvim` | automatic cleanup for unused buffers |

## プラグイン選定メモ

既存の LazyVim / Snacks / Oil / Blink / Noice 構成を基準に、不足する操作を補う。機能が重なる候補は専用キーに割り当て、既存の操作と比較できるようにする。

2026-09-08の[人気・開発状況の調査](plugin-research.md)では、Snacks・Blink・Oilの継続を選んだ。入力ミスを許容する検索のfffと、変更に追従するレビュー画面のCodeDiffを導入した。SidekickとQuickerは追加候補として調査メモに残している。

fffは `<leader>fP` でファイル、`<leader>sF` で内容を検索する。検索画面の `Shift-Tab` でplain・regex・fuzzyを切り替える。通常の検索は LazyVim 既定の Snacks picker で行う。数値だけの開発用タグを避けるため、バージョン範囲を `^0.10.6` に絞っている。

CodeDiffは `<leader>gR` で作業中の変更、`<leader>gV` でステージ済みの変更を表示する。画面内の `t` で左右分割とインラインを切り替え、`q` で閉じる。Diffviewのキーも使える。ネイティブライブラリとCodeDiffの変更監視バイナリはリリースから取得し、プラグインのリビジョンは `lazy-lock.json` で管理する。

| 追加 | 理由 |
| --- | --- |
| `kevinhwang91/nvim-bqf` | quickfix の preview / filter / split open を補強する。既存の Trouble や Snacks picker とは用途が違う |
| Snacks.gitbrowse (`what = "permalink"`) | 現在行や選択範囲の permalink を `<leader>gY` でコピー、`<leader>gB` でブラウザ表示。gitlinker.nvim は LazyVim 既定のこの機能で置き換えた |

## キーマップ

> `L` = LazyVim提供、`C` = カスタム、`P` = プラグイン提供

### 基本操作

| キー        | モード | 説明               | 出典            |
| ----------- | ------ | ------------------ | --------------- |
| `;`         | n      | コマンドモード     | C               |
| `jk` / `jj` | i,c,t  | ESC（遅延なし）    | P better-escape |
| `<C-s>`     | n,i,x  | 保存               | L               |
| `<Esc>`     | n      | 検索ハイライト消去 | L               |

### ナビゲーション

| キー | モード | 説明 | 出典 |
| --- | --- | --- | --- |
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
| --- | --- | --- | --- |
| `<leader><leader>` | n | Smart Picker（ファイル+バッファ+最近使用） | P Snacks |
| `<leader>/` | n | Grep（ルートディレクトリ） | L |
| `<leader>ff` | n | ファイル検索 | L |
| `<leader>fn` | n | 新規ファイル | L |
| `<C-p>` | n | ファイル検索（ルート） | C Snacks |
| `<leader>fP` | n | 入力ミスを許容するファイル検索（ルート） | C fff |
| `-` | n | Oil ファイルエクスプローラ | P oil |
| `<leader>e` | n | Oil ファイルエクスプローラ | P oil |

### 検索 (`<leader>s` prefix)

検索は LazyVim 既定の Snacks picker に統一している。picker 内では `Ctrl-J/K` で移動し、`<Esc>` で閉じる。Smart Picker と変更ファイル一覧も同じ picker を使う。

| キー | モード | 説明 | 出典 |
| --- | --- | --- | --- |
| `<leader>sg` | n | ルートディレクトリをGrep | L Snacks |
| `<leader>sF` | n | 内容検索（plain / regex / fuzzy） | C fff |
| `<leader>sw` | n,x | カーソル下の単語・選択範囲をGrep | L Snacks |
| `<leader>sb` | n | 現在バッファ内の行検索 | L Snacks |
| `<leader>sc` | n | コマンド履歴 | L Snacks |
| `<leader>sh` | n | ヘルプページ | L Snacks |
| `<leader>sk` | n | キーマップ | L Snacks |
| `<leader>sd` | n | 診断一覧 | L Snacks |
| `<leader>ss` | n | LSPシンボル | L Snacks |
| `<leader>sR` | n | 直前の検索を再開 | L Snacks |
| `<leader>st` / `<leader>sT` | n | TODO検索（全て / TODO・FIX・FIXME） | L todo-comments |
| `<leader>sy` | n | ヤンク履歴 | P yanky |

### バッファ管理

| キー         | モード | 説明               | 出典     |
| ------------ | ------ | ------------------ | -------- |
| `<leader>bd` | n      | バッファ削除       | L Snacks |
| `<leader>bo` | n      | 他のバッファを削除 | L Snacks |
| `<leader>bb` | n      | バッファ切替       | L        |

### LSP

| キー         | モード | 説明                                    | 出典      |
| ------------ | ------ | --------------------------------------- | --------- |
| `gd`         | n      | 定義へジャンプ                          | L         |
| `gr`         | n      | 参照一覧                                | L         |
| `gI`         | n      | 実装へジャンプ                          | L         |
| `gy`         | n      | 型定義へジャンプ                        | L         |
| `gD`         | n      | 宣言へジャンプ                          | L         |
| `K`          | n      | ホバー情報                              | L         |
| `<leader>ca` | n,x    | コードアクション                        | L         |
| `<leader>cr` | n      | リネーム（inc-rename ライブプレビュー） | L + Extra |
| `<leader>cf` | n,x    | フォーマット                            | L         |
| `gK`         | n      | シグネチャヘルプ                        | L         |
| `<leader>cd` | n      | 行の診断詳細                            | L         |

### 診断

| キー         | モード | 説明                 | 出典            |
| ------------ | ------ | -------------------- | --------------- |
| `[d` / `]d`  | n      | 前/次の診断          | L               |
| `<leader>xx` | n      | 全診断 (Trouble)     | P trouble       |
| `<leader>xX` | n      | バッファ診断         | P trouble       |
| `<leader>xs` | n      | ドキュメントシンボル | P trouble       |
| `<leader>xl` | n      | LSP定義              | P trouble       |
| `<leader>xq` | n      | Quickfix (Trouble)   | P trouble       |
| `<leader>xt` | n      | TODO一覧             | P todo-comments |
| `[t` / `]t`  | n      | 前/次のTODO          | P todo-comments |

### コードピーク (`<leader>p` prefix)

| キー         | モード | 説明                           | 出典       |
| ------------ | ------ | ------------------------------ | ---------- |
| `<leader>pd` | n      | 定義をピーク（floating popup） | P overlook |
| `<leader>pc` | n      | 全popupを閉じる                | P overlook |
| `<leader>pu` | n      | 最後のpopupを復元              | P overlook |
| `<leader>pU` | n      | 全popupを復元                  | P overlook |
| `<leader>pf` | n      | フォーカス切替                 | P overlook |
| `<leader>ps` | n      | splitで開く                    | P overlook |
| `<leader>pv` | n      | vsplitで開く                   | P overlook |
| `<leader>po` | n      | 元のウィンドウで開く           | P overlook |

### Git (`<leader>g` prefix)

| キー | モード | 説明 | 出典 |
| --- | --- | --- | --- |
| `<leader>gg` | n | LazyGit | P Snacks |
| `<leader>gl` | n | LazyGit Log | P Snacks |
| `<leader>gf` | n | LazyGit ファイル履歴 | P Snacks |
| `<leader>gC` | n | 変更ファイル一覧と差分プレビュー | P Snacks |
| `<leader>gR` | n | 変更に追従する差分レビュー | C CodeDiff |
| `<leader>gV` | n | ステージ済み変更のレビュー | C CodeDiff |
| `<leader>gd` | n | Working tree diff | P diffview |
| `<leader>gD` | n | 前のコミットとのdiff | P diffview |
| `<leader>gs` | n | ステージ済み変更 | P diffview |
| `<leader>gm` | n | mainブランチとの比較 | P diffview |
| `<leader>gM` | n | masterブランチとの比較 | P diffview |
| `<leader>gF` | n | 現在ファイルの履歴 | P diffview |
| `<leader>gH` | n | ブランチ全体の履歴 | P diffview |
| `<leader>gq` | n | Diffview閉じる | P diffview |
| `<leader>gt` | n | ファイルパネル切替 | P diffview |
| `[x` / `]x` | n | 前/次のコンフリクト（Diffview内） | P diffview |
| `<leader>co` / `ct` / `cb` | n | コンフリクトで ours/theirs/base を選択（Diffview内） | P diffview |
| `<leader>gb` | n | 現在行のコミット履歴 | L Snacks |
| `<leader>gh*` | n | Hunk操作グループ（stage/reset/preview/blame/diff） | L gitsigns |
| `<leader>hs` / `<leader>hr` | n,v | Hunkをステージ・アンステージ / リセット | C gitsigns |
| `<leader>hS` / `<leader>hR` | n | バッファ全体をステージ / リセット | C gitsigns |
| `<leader>hp` | n | Hunkをインラインでプレビュー | C gitsigns |
| `<leader>hb` / `<leader>hB` | n | 行のBlame表示 / 現在行Blameの切替 | C gitsigns |
| `<leader>hd` | n | バッファのdiff | C gitsigns |
| `<leader>gB` | n,x | 現在行/選択範囲の permalink をブラウザで開く | L Snacks |
| `<leader>gY` | n,x | 現在行/選択範囲の permalink をコピー | L Snacks |
| `]h` / `[h` | n | 次/前のhunk | L gitsigns |

### トグル (`<leader>u` prefix)

| キー         | モード | 説明                   | 出典                 |
| ------------ | ------ | ---------------------- | -------------------- |
| `<leader>us` | n      | スペルチェック         | L                    |
| `<leader>uw` | n      | 折り返し               | L                    |
| `<leader>ul` | n      | 行番号                 | L                    |
| `<leader>ud` | n      | 診断表示               | L                    |
| `<leader>uh` | n      | インレイヒント         | L                    |
| `<leader>uf` | n      | 自動フォーマット       | L                    |
| `<leader>ub` | n      | ダークバックグラウンド | L                    |
| `<leader>ut` | n      | Treesitterコンテキスト | P treesitter-context |
| `<leader>uz` | n      | Zenモード              | P Snacks             |
| `<leader>uZ` | n      | Zenズーム              | P Snacks             |

### ウィンドウ・スプリット

| キー | モード | 説明 | 出典 |
| --- | --- | --- | --- |
| `<leader>\|` | n | 縦分割 | L |
| `<leader>-` | n | 横分割 | L |
| `<leader>w=` | n | スプリット均等化 | C |
| `<leader>wm` | n | ウィンドウ最大化トグル（`<leader>uZ` と同じ） | L Snacks |
| `<C-Up/Down/Left/Right>` | n | ウィンドウリサイズ | L |

### ビジュアルモード

| キー              | モード | 説明                     | 出典 |
| ----------------- | ------ | ------------------------ | ---- |
| `J` / `K`         | v      | 行を下/上に移動          | C    |
| `<A-j>` / `<A-k>` | n,i,v  | 行を下/上に移動          | L    |
| `<leader>P`       | x      | ペースト（レジスタ保持） | C    |
| `<leader>D`       | n,v    | 削除（レジスタなし）     | C    |

### クリップボード・生産性

| キー | モード | 説明 | 出典 |
| --- | --- | --- | --- |
| `]q` / `[q` | n | 次/前のquickfix | L |
| `<leader>cw` | n | カーソル下の単語をバッファ内で置換（`:%s` を準備） | C |
| `<leader>yp` | n | リポジトリ相対のファイルパスをコピー | C |
| `<leader>yl` | n,x | `path:line` / `path:start-end` をコピー | C |
| `<leader>cx` | n | 現在ファイルに実行権限を付与 | C |
| `zf` | qf | quickfix内をfzf風に絞り込み | P nvim-bqf |
| `<C-x>` / `<C-v>` | qf | quickfix項目を水平/垂直分割で開く | P nvim-bqf |
| `<C-a>` / `<C-x>` | n | インクリメント/デクリメント (dial拡張) | P dial |
| `[y` / `]y` | n | ペースト後にヤンク履歴サイクル | P yanky |

### ターミナル

| キー    | モード | 説明                 | 出典 |
| ------- | ------ | -------------------- | ---- |
| `<c-/>` | n,t    | ターミナルトグル     | L    |
| `<C-x>` | t      | ターミナルモード終了 | C    |

### AIエージェントによる外部編集

エージェントが保存した変更は `<leader>gC` でファイルごとに確認できる。リポジトリのルートを対象に、ステージ前後の変更と未追跡ファイルを一覧にする。まとまった差分の確認には `<leader>gd`、ステージ済み差分には `<leader>gs` を使う。一覧表示には既存の [Snacks Git status picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#git_status) を利用する。

`autoread`と低頻度の`checktime`を利用し、Claude CodeやCodexが保存した未変更bufferは自動的に再読込する。focus/buffer/terminalの切り替えとnormal modeのidle時だけ確認し、カーソル移動ごとのfilesystem確認は行わない。

Neovim側にも未保存の変更がある場合は、バッファを開いた時点の内容を基準に `git merge-file`で3-way mergeする。競合しない変更は両方を保持し、同じ箇所を変更した場合は両方を競合マーカー付きでバッファへ残す。統合結果は未保存のままなので確認後に保存する。ファイル削除時や自動統合できない形式では選択を求める。エージェントへ場所を渡すときは`<leader>yl`で`path:line`形式をclipboardへコピーでき、visual selectionでは行範囲になる。

### セッション (`<leader>q` prefix)

| キー         | モード | 説明                 | 出典          |
| ------------ | ------ | -------------------- | ------------- |
| `<leader>qs` | n      | セッション復元       | L persistence |
| `<leader>ql` | n      | 最後のセッション復元 | L persistence |
| `<leader>qd` | n      | セッション保存停止   | L persistence |
| `<leader>qq` | n      | 全て閉じて終了       | L             |

### AI (`<leader>a` prefix)

| キー | モード | 説明 | 出典 |
| --- | --- | --- | --- |
| `<leader>aa` | n | AI質問 (avante) | P avante |
| `<leader>aE` | n | AIでコード編集 (avante) | P avante |
| `<leader>aS` | n | Avante更新 | P avante |
| `<leader>a1` | n | Avante provider: Codex ACP | P avante |
| `<leader>a2` | n | Avante provider: Claude Code ACP | P avante |
| `<leader>a3` | n | Avante provider: Copilot | P avante |
| `<leader>ax` | n | Codexを起動・フォーカス・非表示 | P codex.nvim |
| `<C-g>` | n,t | Herdr agent attention board / attachから戻る | P signalbox.nvim |
| `<leader>ao` | n | CopilotChat開く | P copilot-chat |
| `<leader>aq` | n,x | Quick Chat（1行で質問） | L copilot-chat |
| `<leader>ar` | n | CopilotChatリセット | P copilot-chat |
| `<leader>am` | n | CopilotChatモデル選択 | P copilot-chat |
| `<leader>ap` | n,x | プロンプト一覧 | L copilot-chat |
| `<leader>ae` | n,v | コード説明 | P copilot-chat |
| `<leader>af` | n,v | コード修正 | P copilot-chat |
| `<leader>aO` | n,v | コード最適化 | P copilot-chat |
| `<leader>at` | n,v | テスト生成 | P copilot-chat |
| `<leader>ad` | n,v | ドキュメント生成 | P copilot-chat |
| `<leader>aR` | n,v | コードレビュー | P copilot-chat |
| `<leader>ag` | n | staged diffレビュー | P copilot-chat |
| `<leader>aG` | n | unstaged diffレビュー | P copilot-chat |
| `<leader>aW` | n | workspace tool chat | P copilot-chat |
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

### Codex (`<leader>o` prefix)

CodexとAvanteのCodex ACPは `gpt-6-astra`、CopilotChatとAvanteのCopilotは
`claude-opus-5` を使う。Claude CodeとAvanteのClaude Code ACPは `best` を指定し、
利用できる最新のFable、対象外ならOpusを使う。

| キー | モード | 説明 | 出典 |
|---|---|---|---|
| `<leader>oo` / `<leader>ax` | n | Codexを起動・フォーカス・非表示 | P codex.nvim |
| `<leader>op` | n | プロンプト入力 | P codex.nvim |
| `<leader>om` | n | 次の操作を選ぶ | C |
| `<leader>ou` | n | 同じ会話への追加依頼を複数行で書く | P codex.nvim |
| `<leader>od` | n | Codexの作業プロジェクトの差分をCodeDiffで確認 | C |
| `<leader>oh` | n | 会話を残して編集へ戻る | P codex.nvim |
| `<leader>oa` | n,x | Ask: 現在ファイル / 選択範囲を添えて依頼を作成 | P codex.nvim |
| `<leader>oe` | x | Edit: 選択範囲への変更依頼を作成 | P codex.nvim |
| `<leader>os` | n,x | 現在行 / 選択範囲を送信 | P codex.nvim |
| `<leader>ob` | n,x | 現在バッファの`@path` / 選択範囲を入力欄へ追加（送信しない） | P codex.nvim |
| `<leader>ot` | n | Oilで選んだファイルを追加 | P codex.nvim |
| `<leader>or` / `<leader>oc` / `<leader>of` | n | セッションを選んで再開 / 直近を再開 / フォーク | P codex.nvim |
| `<leader>oR` | n | 未コミット変更のレビュー依頼を作成（Ctrl-Sで送信） | C |
| `<leader>oS` / `<leader>oq` | n | 状態表示 / 停止 | P codex.nvim |

選択中は範囲の下に `[Codex <leader>oa: Ask, <leader>oe: Edit]` を表示する。
依頼画面は入力モードで開く。指示と添付コードを編集し、`Ctrl-S` または `:write` で送信する。
`Ctrl-P` で説明・修正・テスト追加・リファクタの指示を選び、`Ctrl-D` で診断、
`Ctrl-F` でファイルを追加できる。Normal mode の `q` で下書きを残して閉じ、
`<leader>oa` で再表示する。破棄する場合は依頼画面で `:bdelete!` を使う。
Avanteの `aa: ask / aE: edit` も同時に表示し、依頼先を選べる。

送信すると依頼画面が閉じ、右側のCodexで起動状態・承認要求・回答を確認できる。
送信に失敗した場合は下書きを再表示する。回答画面の上部には
`Alt-a Actions / Alt-d Diff / Alt-q Hide` を常時表示する。
初めて開くプロジェクトではCodexの信頼確認が表示されることがある。
内容を確認して進むと、待機中の依頼が送信される。

1. 回答後はそのまま入力してEnterで追加依頼する。複数行で書く場合は `Alt-a` の「追加依頼を書く」または `<leader>ou` を使い、`Ctrl-S` で送る。端末の表示内容は自動添付しない。
2. `Alt-d` または `<leader>od` でCodeDiffを開き、変更を確認する。`q` で元のタブへ戻る。Codex起動後に別のプロジェクトを開いても、差分の対象はCodexの作業ディレクトリを使う。
3. `Alt-q` または `<leader>oh` で編集画面へ戻る。会話は動き続け、`<leader>oo` で再表示できる。保存された変更は既存の外部変更検知で編集画面へ反映される。

回答をスクロール・コピーするときは `Esc Esc` でNormal modeへ移り、通常の移動と選択・`y` を使う。`i` でCodexへの入力に戻る。承認や実行中の中断はCodex画面の案内に従う。`<leader>oq` はプロセスの停止なので、単に隠す場合は `Alt-q` を使う。

差分には同じ作業ツリー内の既存の変更も含まれる。Codex経由のEditはファイルを変更する操作で、Avanteの提案パッチとは異なり、後から「採用」を押す方式ではない。ステージ・取り消しはCodeDiffや既存のGit操作で必要な変更だけを選ぶ。

### Codelens

| キー         | モード | 説明         | 出典         |
| ------------ | ------ | ------------ | ------------ |
| `<leader>cc` / `<leader>cC` | n | Codelensを実行 / 更新 | L |

### Rust (`<leader>r` prefix, Rustファイルのみ)

| キー         | モード | 説明                 | 出典           |
| ------------ | ------ | -------------------- | -------------- |
| `<leader>ra` | n      | Rustコードアクション | P rustaceanvim |
| `<leader>rd` | n      | デバッグ可能一覧     | P rustaceanvim |
| `<leader>rr` | n      | 実行可能一覧         | P rustaceanvim |
| `<leader>rR` | n      | 前回の実行を再実行   | P rustaceanvim |
| `<leader>rt` | n      | テスト可能一覧       | P rustaceanvim |
| `<leader>rT` | n      | 前回のテストを再実行 | P rustaceanvim |
| `<leader>rm` | n      | マクロ展開           | P rustaceanvim |
| `<leader>rc` | n      | Cargo.tomlを開く     | P rustaceanvim |
| `<leader>rp` | n      | 親モジュール         | P rustaceanvim |

### Crates (`<leader>r` prefix, Cargo.tomlのみ)

| キー          | モード | 説明                     | 出典           |
| ------------- | ------ | ------------------------ | -------------- |
| `<leader>rt` | n      | Cratesトグル             | P crates       |
| `<leader>rr` | n      | Cratesリロード           | P crates       |
| `<leader>rv` | n      | バージョン一覧           | P crates       |
| `<leader>rf` | n      | Feature一覧              | P crates       |
| `<leader>rd` | n      | 依存関係一覧             | P crates       |
| `<leader>ru` | n,v    | クレート更新             | P crates       |
| `<leader>rU` | n,v    | クレートアップグレード   | P crates       |
| `<leader>rA` | n      | 全クレートアップグレード | P crates       |
| `<leader>rH` | n      | ホームページを開く       | P crates       |
| `<leader>rR` | n      | リポジトリを開く         | P crates       |
| `<leader>rD` | n      | docs.rsを開く            | P crates       |
| `<leader>rC` | n      | crates.ioを開く          | P crates       |
| `<leader>rj`  | n      | 行結合                   | P rustaceanvim |
| `<leader>rs`  | n      | 構造的検索置換           | P rustaceanvim |
| `<leader>re`  | n      | エラー説明               | P rustaceanvim |
| `<leader>rD`  | n      | 診断レンダリング         | P rustaceanvim |
| `<leader>rv`  | n      | HIR表示                  | P rustaceanvim |
| `<leader>rV`  | n      | MIR表示                  | P rustaceanvim |
| `K`           | n      | Rustホバーアクション     | P rustaceanvim |

### テスト (`<leader>t` prefix)

| キー         | モード | 説明                   | 出典      |
| ------------ | ------ | ---------------------- | --------- |
| `<leader>tr` | n      | 最寄りテスト実行       | L neotest |
| `<leader>tt` | n      | ファイルテスト実行     | L neotest |
| `<leader>tT` | n      | 全テストファイル実行   | L neotest |
| `<leader>tl` | n      | 前回のテストを再実行   | L neotest |
| `<leader>ts` | n      | テストサマリー切替     | L neotest |
| `<leader>to` | n      | テスト出力表示         | L neotest |
| `<leader>tO` | n      | 出力パネル切替         | L neotest |
| `<leader>tS` | n      | テスト停止             | L neotest |
| `<leader>tw` | n      | ファイル監視切替       | L neotest |
| `<leader>td` | n      | 最寄りテストをデバッグ | L neotest |
| `[T` / `]T`  | n      | 前/次の失敗テスト      | C neotest |

### デバッグ (`<leader>d` prefix)

| キー         | モード | 説明                     | 出典  |
| ------------ | ------ | ------------------------ | ----- |
| `<leader>db` | n      | ブレークポイント切替     | P dap |
| `<leader>dB` | n      | 条件付きブレークポイント | P dap |
| `<leader>dc` | n      | Continue                 | P dap |
| `<leader>dC` | n      | カーソルまで実行         | P dap |
| `<leader>di` | n      | Step into                | P dap |
| `<leader>do` | n      | Step over                | P dap |
| `<leader>dO` | n      | Step out                 | P dap |
| `<leader>dp` | n      | Pause                    | P dap |
| `<leader>dr` | n      | REPL切替                 | P dap |
| `<leader>dt` | n      | Terminate                | P dap |
| `<leader>du` | n      | DAP UI切替               | P dap |
| `<leader>de` | n,v    | Eval                     | P dap |

### リファクタリング (`<leader>R` prefix)

| キー         | モード | 説明                     | 出典          |
| ------------ | ------ | ------------------------ | ------------- |
| `<leader>Rf` | n,x    | Extract Function         | P refactoring |
| `<leader>RF` | n,x    | Extract Function to File | P refactoring |
| `<leader>Rv` | n,x    | Extract Variable         | P refactoring |
| `<leader>Ri` | n,x    | Inline Variable          | P refactoring |
| `<leader>Rp` | n      | Debug Print Location     | P refactoring |
| `<leader>RP` | n,x    | Debug Print Variable     | P refactoring |
| `<leader>Rc` | n      | Debug Print 全削除       | P refactoring |
| `<leader>Rs` | n,x    | Refactoring Selector     | P refactoring |

## インストール

```bash
# 既存の別設定はlink.shがバックアップしてからリンクする
cd ~/ghq/github.com/nwiizo/dotfiles
rtk proxy ./scripts/link.sh

# Neovim起動（プラグイン自動インストール）
rtk proxy nvim
```

`lazy-lock.json` はlazy.nvim公式推奨どおりバージョン管理する。別マシンでは `:Lazy restore` でlockfileのrevisionへ復元できる。`:Lazy update` によるrevision更新は、関連する設定変更と一緒にレビュー・コミットする。

## メンテナンス

設定変更は新しく起動したNeovimに反映される。リポジトリのルートで検証する。

```sh
rtk proxy stylua --check nvim/lua
rtk proxy jq empty nvim/lazy-lock.json
rtk proxy nvim --headless '+lua print("nvim-config-ok")' +qa
```

遅延読み込みの設定を変えた場合は対象プラグインを読み込み、操作も確認する。外部変更と未保存編集のマージを変更した場合は `rtk proxy nvim --headless -u NONE -l nvim/tests/external_changes.lua` で空行、末尾改行、競合時の内容保持、Undoを検証する。

Codexの操作は `rtk proxy nvim --headless -u nvim/init.lua '+lua dofile("nvim/tests/codex_workflow.lua")'` で検証する。選択からEdit・送信・回答・追加依頼・CodeDiff・編集への復帰まで、インストール済みプラグインとテスト用ターミナルで操作する。同じコマンドの `nvim` の前に `env CODEX_NVIM_REAL_CLI=1` を入れると、認証済みCodex CLIを使い、一時リポジトリ内のファイル変更と追加依頼の2ターンを実行する。

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
- ripgrep (Snacks picker)
