# Neovim Configuration

LazyVimベースのNeovim設定。Rust、Go、TypeScript、Python開発とAI支援コーディングに最適化。

ステータスラインを省き、コードとエージェント用のターミナルに表示領域を使う。

## 概要

- **ベース**: [LazyVim v16.0.1](https://github.com/LazyVim/LazyVim/releases/tag/v16.0.1)（2026-10-10確認）
- **テーマ**: catppuccin mocha
- **補完**: blink.cmp
- **要件**: Neovim 0.12+
- **UI哲学**: 最小限のUI、最大限の編集領域

## 読み方

この README は操作・構成・検証の案内。[AGENTS.md](AGENTS.md) には設定変更時の
判断基準と、この環境で保つ動作をまとめている。`CLAUDE.md` は `AGENTS.md` への
相対シンボリックリンクなので、ルールの更新は `AGENTS.md` に行う。
[AGENTS.md の公式案内](https://agents.md/)に沿って、Neovim 固有の指示をこのディレクトリへまとめている。

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

`setup(opts)` だけなら `config` は書かず、lazy.nvim に任せる。Incline のイベント連携や
Codex の独自コマンドのように、初期化後の処理が必要なものだけ `config` を残す。
編集操作は `coding.lua`、表示は `ui.lua` にまとめる。

### 読み込みと依存の方針

| 対象 | 方針 |
| --- | --- |
| LazyVim / Extras の標準機能 | 変更する値だけを指定する。HTML/JSX のタグ補完は標準の nvim-ts-autotag に任せる。 |
| キー・コマンドで使う機能 | `keys` / `cmd` で読み込む。これらがあれば通常 `lazy = true` の追加は不要。 |
| 常時使う表示・連携 | UI は `VeryLazy`、better-escape は `User LazyVimKeymaps`。選択ヒントや外部接続を持つ AI 連携も初期化順を保つ。 |
| 起動時に必要な機能 | テーマと Oil は先に読み込む。Oil はディレクトリを直接開く動作のため、公式推奨どおり `lazy = false`。 |
| バージョンとローカル開発 | 通常のプラグインは `lazy-lock.json` で管理する。`dir` 指定の codex・signalbox・cargo・marp は `~/ghq/github.com/nwiizo/` の作業ツリーを使い、lockfile の復元対象には含まれない。 |

読み込み条件は [lazy.nvim の説明](https://lazy.folke.io/spec/lazy_loading)、
Oil の例外は [公式の導入手順](https://github.com/stevearc/oil.nvim#installation)を参照。
ローカル開発の4リポジトリは別途配置しておく。

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
| ファイル選択     | Television         | Fishと同じ検索画面・配色       |

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
├── README.md                   # 操作・構成・検証
├── AGENTS.md                   # 設定変更時の方針
├── CLAUDE.md -> AGENTS.md       # Claude向けの共通入口
├── tests/                      # headlessで実操作を検証
└── lua/
    ├── config/
    │   ├── lazy.lua            # lazy.nvim bootstrap + Extras
    │   ├── options.lua         # Vimオプション
    │   ├── keymaps.lua         # カスタムキーマップ
    │   ├── autocmds.lua        # カスタムautocmd
    │   └── television.lua     # Televisionとの接続、quickfix変換
    └── plugins/
        ├── disabled.lua        # LazyVimデフォルト無効化
        ├── colorscheme.lua     # catppuccin mocha
        ├── ui.lua              # incline, modes, vimade, noice, which-key
        ├── navigation.lua      # Television, Snacks, Telescope, fff, oil, overlook, treewalker, hbac
        ├── git.lua             # gitsigns override, codediff, diffview
        ├── diagnostics.lua     # trouble, todo-comments, quicker, nvim-bqf
        ├── lsp.lua             # lspconfig, conform, mason, treesitter override
        ├── completion.lua      # blink.cmp override
        ├── coding.lua          # escape, surround, pairs, textobjects, matchup, yanky, refactoring, treesj
        ├── ai.lua              # copilot, copilot-chat, avante, codex, claudecode, signalbox
        └── lang.lua            # rustaceanvim, crates, neotest, dap, cargo, marp
```

## 有効化している LazyVim Extras

### 言語サポート

| Extra             | 内容                                            |
| ----------------- | ----------------------------------------------- |
| `lang.rust`       | rustaceanvim + crates.nvim + rustaceanvim.neotest + DAP |
| `lang.go`         | gopls + neotest-golang                          |
| `lang.python`     | pyright + ruff                                  |
| `lang.typescript` | vtsls                                           |
| `lang.json`       | jsonls + schemastore                            |
| `lang.yaml`       | yamlls + schemastore                            |
| `lang.markdown`   | render-markdown（markdownlint は無効化）          |
| `lang.terraform`  | terraform-ls                                    |
| `lang.docker`     | dockerls + Compose LSP + hadolint                |
| `lang.toml`       | taplo                                           |
| `lang.git`        | Git関連ファイルのTreesitter構文解析              |

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

2026-09-08の[人気・開発状況の調査](plugin-research.md)では、Snacks・Blink・Oilの継続を選んだ。入力ミスを許容する検索のfffと、変更に追従するレビュー画面のCodeDiffを導入した。2026-09-29にはQuickerを追加し、新作プラグインの調査結果も同じメモに追記した。

2026-10-10の[設定整理](plugin-config-review.md)では、公式の読み込み方と実際の設定を照合し、
編集系の配置・`opts` の使い方・標準設定との重複を整理した。
さらに Star 数と既存構成への適性を比較し、専用の入口から使う Telescope を追加した。
同じメモに、2026-09-24の Overlook・better-escape・Oil の修正記録も残している。

2026-10-27には [mini.align と multicursor.nvim](plugin-research.md#2026-10-27-整列と複数箇所の編集) を追加した。
表や代入文の整列と、選んだ単語だけの同時編集を補う。どちらも初回のキー操作で読み込む。

2026-09-15に通常のファイル・本文検索とquickfixの絞り込みをTelevisionへ移行した。設定はFishと共通で、接続処理は `lua/config/television.lua` に置く。Smart Picker、ステージ操作付き変更一覧、LSPなどの検索はSnacks、入力ミス補正とplain・regex・fuzzy検索はfffを元のキーで使える。[操作・機能差・検証方法](../television/README.md)を参照。

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
| `jk` | x,s | 選択モードを終了 | P better-escape |
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
| `<leader><leader>` | n | Smart Picker（ルートのファイル・バッファ・最近使用） | P Snacks |
| `<leader>fp` | n | Projects（ghq配下と最近開いたリポジトリ） | P Snacks |
| `<leader>fm` | n | 未保存バッファ一覧（現在のバッファも含む） | C Snacks |
| `<leader>/` | n | 本文検索（ルート） | C Television |
| `<leader>ff` / `<leader>fF` | n | ファイル検索（ルート / cwd） | C Television |
| `<leader>fn` | n | 新規ファイル | L |
| `<C-p>` | n | ファイル検索（ルート） | C Television |
| `<leader>fP` | n | 入力ミスを許容するファイル検索（ルート） | C fff |
| `<leader>fT` | n | Telescopeの検索メニュー | P telescope |
| `-` | n | Oil ファイルエクスプローラ | P oil |
| `<leader>e` | n | Oil ファイルエクスプローラ | P oil |

### 検索 (`<leader>s` prefix)

通常のファイル・本文検索はTelevisionを使う。`Ctrl-J/K` で移動、`Tab` で複数選択、`Ctrl-Q` でquickfixへ送り、`Esc` で閉じる。本文検索はripgrepが返す行をTelevisionで絞り込む。入力ミス補正やlive regex検索はfff、エディタ内部の検索はSnacksが担当する。

| キー | モード | 説明 | 出典 |
| --- | --- | --- | --- |
| `<leader>sg` | n | 本文検索（ルート） | C Television |
| `<leader>sF` | n | 内容検索（plain / regex / fuzzy） | C fff |
| `<leader>sG` | n | 本文検索（cwd） | C Television |
| `<leader>sq` | n | quickfixを検索して移動 | L Snacks |
| `<leader>sw` | n,x | カーソル下の単語・選択範囲をGrep | L Snacks |
| `<leader>sb` | n | 現在バッファ内の行検索 | L Snacks |
| `<leader>sc` | n | コマンド履歴 | L Snacks |
| `<leader>sh` | n | ヘルプページ | L Snacks |
| `<leader>sk` | n | キーマップ | L Snacks |
| `<leader>sd` | n | 診断一覧 | L Snacks |
| `<leader>ss` | n | LSPシンボル | L Snacks |
| `<leader>sR` | n | 直前の検索を再開 | L Snacks |
| `<leader>sP` | n | Snacksの検索機能一覧 | C Snacks |
| `<leader>su` | n | Undo履歴のプレビューと復元 | L Snacks |
| `<leader>st` / `<leader>sT` | n | TODO検索（全て / TODO・FIX・FIXME） | L todo-comments |
| `<leader>sy` | n,x | ヤンク履歴 | P yanky |

#### Snacks Pickerの標準機能と使い分け

2026-09-15に[LazyVimの公式設定](https://www.lazyvim.org/extras/editor/snacks_picker)と
[Snacksの公式ドキュメント](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md)を確認した。
SnacksはLazyVimの標準Pickerで、導入済みの `882c996` は確認時の上流mainと一致する。
LSP・履歴・診断・Undo・Git操作は標準の連携を使う。fzf本体への依存はない。

Smart Pickerは、開いているバッファ・最近使ったファイル・プロジェクト内のファイルをまとめ、
利用頻度と最近の利用状況で並べる。検索起点はLazyVimが判定するルートに揃え、他のプロジェクトの
履歴も残す。Projectsは `~/ghq/<host>/<owner>/<repo>` の `.git` を探すため、深さ4まで探索する。
`<leader>sP` から検索機能を探せるので、使用頻度が低い機能に個別のキーを増やす必要はない。

Snacksの入力欄では次の標準操作が使える。Gitなど一部の検索では専用操作が優先されるため、
その画面の `?`（Normalモード）でキーを確認する。

| 操作 | キー |
| --- | --- |
| 複数選択 / 検索結果を一括選択 | `Tab` / `Ctrl-A` |
| 選択項目をquickfixへ送る | `Ctrl-Q` |
| 分割 / 縦分割 / 新しいタブで開く | `Ctrl-S` / `Ctrl-V` / `Ctrl-T` |
| 表示先ウィンドウを選んで開く | `Shift-Enter` |
| ルートとcwdの切り替え | `Alt-C` |
| 隠しファイル / ignore対象の表示切り替え | `Alt-H` / `Alt-I` |
| プレビュー / 最大化の切り替え | `Alt-P` / `Alt-M` |
| 入力履歴を移動 | `Ctrl-Up` / `Ctrl-Down` |

画面幅に応じた横・縦レイアウトの切り替え、LSP移動時の既存ウィンドウの再利用、
Git差分の色付きプレビューも公式の既定動作を引き継ぐ。Televisionのquickfix内で一括選択が
必要になった場合も、`<leader>sq` のSnacksで絞り込み、`Ctrl-A` → `Ctrl-Q` を使える。

### バッファ管理

| キー         | モード | 説明               | 出典     |
| ------------ | ------ | ------------------ | -------- |
| `<leader>bd` | n      | バッファ削除       | L Snacks |
| `<leader>bo` | n      | 他のバッファを削除 | L Snacks |
| `<leader>bi` | n      | 表示していないバッファを削除 | L Snacks |
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
| `<leader>pp` | n      | 現在位置をピーク（LSP不要）    | P overlook |
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
| `<leader>gT` | n | 変更ファイル一覧と差分プレビュー | C Television |
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
| `zf` | qf | quickfixをTelevisionで絞り込み | C Television |
| `>` / `<` | qf | 検索結果の前後2行を追加表示 / 折りたたむ | P quicker |
| `<C-x>` / `<C-v>` | qf | quickfix項目を水平/垂直分割で開く | P nvim-bqf |
| `<C-a>` / `<C-x>` | n | インクリメント/デクリメント (dial拡張) | P dial |
| `[y` / `]y` | n | ペースト後にヤンク履歴サイクル | P yanky |
| `gA` | n,x | 範囲を整列してプレビュー。区切り文字を入力しEnterで確定、Escで取消 | P mini.align |
| `<C-n>` | n,x | 次の同じ単語・選択文字列にカーソルを追加 | P multicursor |
| `<leader>cN` | n,x | 次の一致箇所をスキップ | P multicursor |
| `<Esc>` | n | 複数カーソルを解除（複数カーソルの使用中のみ） | P multicursor |

整列は `V` で複数行を選び、`gA` → `=` → Enter と押すと代入文の `=` が揃う。
Markdownの表は区切り文字に `|` を使う。Normalモードでは `gAip` で段落を対象にできる。
Vim標準の `ga`（文字コード表示）は維持する。

複数箇所の編集は単語にカーソルを置き、`Ctrl-N` で編集対象を増やしてから `ciw` で書き換える。
InsertモードからEscで戻り、もう一度Escで複数カーソルを解除する。
Insertモードの `Ctrl-N` は既存の補完候補選択のまま。

Televisionで検索結果を `Ctrl-Q` で送ると、quickfix上で本文を編集できる。
閉じた一覧は `:copen` で開く。quickfix内の `:w` は変更を元バッファへ反映し、
ファイルの保存は行わない。`<leader>fm` で変更バッファを確認してから保存する。
ファイル名や行の並びは変えず、本文だけを編集する。

`:%s/旧/新/g` や `<leader>cw` による置換では、入力中に別ウィンドウにも
変更候補を表示する（`inccommand=split`）。Enterで確定、Escで取り消す。

### ターミナル

| キー    | モード | 説明                 | 出典 |
| ------- | ------ | -------------------- | ---- |
| `<c-/>` | n,t    | ターミナルトグル     | L    |
| `<C-x>` | t      | ターミナルモード終了 | C    |

### AIエージェントによる外部編集

エージェントが保存した変更は `<leader>gC` で確認でき、Snacksのステージ・復元操作も使える。`<leader>gT` はTelevisionの `git-diff` チャンネルで、ステージ前後の変更と未追跡ファイルを一覧にする。まとまった差分の確認には `<leader>gd`、ステージ済み差分には `<leader>gs` を使う。

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
| `<leader>aa` | n,x | AI質問 (avante) | P avante |
| `<leader>aN` | n,x | Avanteの新規チャット | P avante |
| `<leader>aE` | x | 選択範囲をAIで編集 (avante) | P avante |
| `<leader>aS` | n | Avante更新 | P avante |
| `<leader>aX` | n | Avante停止 | P avante |
| `<leader>az` | n,x | Avante Zenモード | P avante |
| `<leader>ah` / `<leader>a?` | n | Avanteの履歴 / モデル選択 | P avante |
| `<leader>aB` / `<leader>aC` | n | 全バッファをAvanteへ追加 / 選択ヒントの切り替え | P avante |
| `<leader>as` | n | Avante自動提案の切り替え（初期状態は無効） | P avante |
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

AI 共通のキーは `ai.lua` の `keys` で管理し、Avante の自動キー登録は無効にしている。
読み込み順による上書きを避けるため、Claude の差分拒否は `an`、Avante の新規チャットは
`aN` に分ける。Avante の更新 `aS` と停止 `aX` も別のキーを使う。
Insert モードの `Alt-j` / `Alt-k` は Copilot の行単位 / 単語単位の補完確定に使う。
Normal・Visual モードでは LazyVim の行移動を維持する。

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
依頼画面は入力モードで開き、上部の先頭に `Ctrl-S Send` を表示する。指示と添付コードを編集し、`Ctrl-S` または `:write` で送信する。
`Ctrl-P` で説明・修正・テスト追加・リファクタの指示を選び、`Ctrl-D` で診断、
`Ctrl-F` でファイルを追加できる。Normal mode の `q` で下書きを残して閉じ、
`<leader>oa` で再表示する。破棄する場合は依頼画面で `:bdelete!` を使う。
Avanteの `aa: ask / aE: edit` も同時に表示し、依頼先を選べる。

送信すると依頼画面が閉じ、右側のCodexで起動状態・承認要求・回答を確認できる。
送信に失敗した場合は下書きを再表示する。回答画面の上部には
`Alt-a Actions / Alt-d Diff / Alt-q Hide` を常時表示する。
初めて開くプロジェクトではCodexの信頼確認が表示されることがある。
内容を確認して進むと、待機中の依頼が送信される。

1. 回答後はそのまま入力してEnterで追加依頼する。複数行で書く場合は `Alt-a` の「Write a follow-up」または `<leader>ou` を使い、`Ctrl-S` で送る。端末の表示内容は自動添付しない。
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

Telescope は `<leader>fT` または `:Telescope` から使う。通常のファイル・本文検索は
Television、構造化した一覧は Snacks のまま、Telescope の検索メニューと拡張機能を
必要に応じて選べる。公式推奨の native sorter を併用し、最新のリリースタグを
`version = "*"` で選び、取得したリビジョンを lockfile に記録する。
既存の Terraform Extra により、Terraform/HCL を開くとドキュメント検索と state 一覧の
Telescope 拡張も読み込まれる。例えば `:Telescope terraform_doc full_name=hashicorp/aws`
で AWS provider の資料を検索できる。導入判断と Star 数は [調査記録](plugin-research.md)を参照。

### バージョン更新

2026-10-10 時点で、lockfile と導入済み LazyVim はともに v16.0.1
（`999700997f72227187d49d8b92667183dc7fc809`）。
[v16.0.0](https://github.com/LazyVim/LazyVim/releases/tag/v16.0.0) の refactoring.nvim v2 対応に合わせ、
`coding.lua` は操作別 API と `refactoring.debug` を使う。
[v16.0.1](https://github.com/LazyVim/LazyVim/releases/tag/v16.0.1) の修正は nvim-lint の
`prepend_args` と TypeScript の `tsc` への変更。該当処理は LazyVim に任せ、
TypeScript の LSP は引き続き vtsls を使う。

更新前に対象リリースの変更履歴と導入済みの設定を照合し、必要なプラグインだけを更新する。
`lazy-lock.json` の差分も設定と一緒に確認する。`:Lazy restore` は記録されたリビジョンを
復元するが、`dir` 指定のローカルプラグインは別途管理する。
詳細は [lazy.nvim の lockfile 管理](https://lazy.folke.io/usage/lockfile)を参照。

### ネイティブライブラリと既存の調整

Cargo のローカルプラグインはネイティブライブラリが必要。
初回配置後やライブラリが見つからない場合は `:Lazy build cargo.nvim` で
`cargo build --locked --release` を実行してから Neovim を再起動する。

Avante のネイティブライブラリは `target/lua` にビルドしてから `lua/` へ移す。
使用済みの `.so` へ直接上書きすると、macOS の署名キャッシュと不整合が生じ、
起動直後に `Code Signature Invalid` で終了することがあるため。
再ビルドには、この設定を読み込んだ Neovim で `:Lazy build avante.nvim` を使う。
この置き換え方は [Apple の更新手順](https://developer.apple.com/documentation/security/updating-mac-software)に沿い、
[Avante の Makefile](https://github.com/avante-corp/avante.nvim/blob/main/Makefile)の `BUILD_DIR` を指定している。

Avante のログレベルは、モジュールを読み込む前に `WARN` の文字列で指定する。
[上流のログ処理](https://github.com/avante-corp/avante.nvim/blob/main/lua/avante/utils/log.lua)は対応表を走査しながら数値キーを追加しており、
[Lua の仕様](https://www.lua.org/manual/5.1/manual.html#pdf-next)ではこの走査結果が保証されない。
文字列での指定は、警告の出力を保ったまま `Invalid log level: 3` を回避する。
上流で対応表の作り方が修正されたら、この指定を見直す。

Python は [Ruff の推奨順序](https://docs.astral.sh/ruff/formatter/#sorting-imports)に合わせ、
import 整理の後に整形する。Incline の診断件数は
[`vim.diagnostic.count()`](https://neovim.io/doc/user/diagnostic/#vim.diagnostic.count())で取得し、
描画のたびにエラー・警告の診断一覧をそれぞれコピーしない。

### 検証

```sh
rtk proxy stylua --check nvim/lua
rtk proxy jq empty nvim/lazy-lock.json
rtk proxy nvim --headless '+lua print("nvim-config-ok")' +qa
```

遅延読み込みの設定を変えた場合は対象プラグインを読み込み、操作も確認する。外部変更と未保存編集のマージを変更した場合は `rtk proxy nvim --headless -u NONE -l nvim/tests/external_changes.lua` で空行、末尾改行、競合時の内容保持、Undoを検証する。

`nvim/tests/plugin_config.lua` は `UIEnter` から通常の遅延読み込みを実行し、Avante の
コマンド登録・ヘルプ実行・ログ・ライブラリ読み込み、Incline の診断件数、
Ruff による import 整理・整形と2回目の整形で差分が出ないことを検証する。
次の例は `HOME` と XDG ディレクトリを分離して実行する。設定はコピーし、導入済みの
プラグイン・Mason・パーサーとローカル開発リポジトリを参照する。
この環境ではプラグインの更新・ビルドを実行せず、認証済みAIへのリクエストも行わない。

```sh
nvim_test_dir=$(rtk proxy mktemp -d)
nvim_data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
rtk proxy mkdir -p "$nvim_test_dir/config" "$nvim_test_dir/data/nvim" \
  "$nvim_test_dir/state" "$nvim_test_dir/cache" \
  "$nvim_test_dir/home/ghq/github.com/nwiizo"
rtk proxy cp -R nvim "$nvim_test_dir/config/nvim"
for component in lazy mason site; do
  rtk proxy ln -s "$nvim_data_dir/$component" "$nvim_test_dir/data/nvim/$component"
done
for plugin in codex.nvim signalbox.nvim cargo.nvim marp.nvim; do
  rtk proxy ln -s "$HOME/ghq/github.com/nwiizo/$plugin" \
    "$nvim_test_dir/home/ghq/github.com/nwiizo/$plugin"
done
rtk proxy env HOME="$nvim_test_dir/home" \
  XDG_CONFIG_HOME="$nvim_test_dir/config" XDG_DATA_HOME="$nvim_test_dir/data" \
  XDG_STATE_HOME="$nvim_test_dir/state" XDG_CACHE_HOME="$nvim_test_dir/cache" \
  nvim --headless -i NONE '+lua dofile("nvim/tests/plugin_config.lua")'
```

以下のテストも、最後のコマンドのファイル名を変えて同じ分離環境で実行する。
`nvim/tests/editing_plugins.lua` は実際のキー入力で初回読み込み、整列と取消、
複数箇所の編集とスキップ、Escによる解除と元のキー設定への復帰、Undoを確認する。
AI 共通キーと Yanky の変更では `tests/keymap_conflicts.lua` を使う。
Claude Code・CopilotChat を先に読み込み、Avante が他のキーを上書きしないこと、
停止と更新の呼び分け、Visual モードのヤンク履歴を検証する。AI の実処理だけを置き換え、
実際のキー入力を通す。

同じ分離環境で `nvim/tests/navigation_plugins.lua` と `nvim/tests/escape_modes.lua` も
それぞれ `+lua dofile(...)` で実行する。前者は Overlook のプレビュー・復元・分割と、
Oil の外部変更への追従・未保存編集の保持を検証する。定義の LSP 応答だけをテスト用に置き換える。
後者は起動後最初の Visual 選択、Select・Insert モードでの `jk` を検証する。
両テストは headless 起動で発生しない `UIEnter` を再現し、通常の遅延読み込みも実行する。

`nvim/tests/refactoring.lua` は Normal・Visual モードでデバッグ出力を追加し、
`<leader>Rc` で元のコードや既存の `print` を残して削除できることを検証する。
このキーは mini.ai のバッファ全体の範囲 `ag` を使うため、`remap = true` が必要。

`nvim/tests/quickfix_editing.lua` も同じ分離環境で実行する。quickfixを開いてからの
遅延読み込み、前後行の展開・折りたたみ、既存キーの共存、複数バッファへの編集反映、
既存の未保存編集とディスク上の内容が保持されることを検証する。

`nvim/tests/codex_workflow.lua` も通常は上記の分離環境で実行する。
選択からEdit・送信・回答・追加依頼・CodeDiff・編集への復帰まで、
インストール済みプラグインとテスト用ターミナルで操作する。
実サービスの確認を明示的に依頼された場合だけ、通常の認証環境で
`rtk proxy env CODEX_NVIM_REAL_CLI=1 nvim --headless -i NONE -u nvim/init.lua '+lua dofile("nvim/tests/codex_workflow.lua")'`
を使う。一時リポジトリ内でファイル変更と追加依頼の2ターンを実行するため、通常の回帰テストとは分ける。

API の移行時は対象操作を実行した後の `:checkhealth vim.deprecated`、Treesitter の
更新時は `:checkhealth nvim-treesitter` も確認する。`:checkhealth which-key` はキーの
重複確認を補助するが、同じキーの上書きは残らないため、読み込み順の回帰テストも使う。
ルールを編集した場合は `rtk proxy ./scripts/audit-agent-config.sh` で参照とリンクを検証する。

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
