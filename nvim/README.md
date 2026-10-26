# Neovim Configuration

エージェントに実装を任せ、人がコードを理解・レビュー・修正するためのLazyVim設定。
Rust、Go、TypeScript、Pythonなどを扱い、コード・差分・実行結果に表示領域を使う。

## 概要

- **ベース**: [LazyVim v16.0.1](https://github.com/LazyVim/LazyVim/releases/tag/v16.0.1)（2026-10-10確認）
- **テーマ**: catppuccin mocha
- **補完**: blink.cmp
- **要件**: Neovim 0.12+
- **UI哲学**: 最小限のUI、最大限の編集領域

## 読み方

このREADMEは日常の作業と設計方針の入口。詳細は目的ごとに分ける。

| 目的 | 読む文書 |
| --- | --- |
| 日常の作業・設定の役割を知る | このREADME |
| 操作やキーを調べる | [キーマップ](keymaps.md) |
| 更新・不具合調査・検証を行う | [メンテナンス](maintenance.md) |
| 設定を編集する | [AGENTS.md](AGENTS.md)。`CLAUDE.md` はこのファイルへのリンク |
| 導入時の判断や根拠を調べる | [プラグイン調査](plugin-research.md)、[設定の確認記録](plugin-config-review.md)。日付時点の記録として読む |

## 日常のレビュー

`<leader>` はSpace。Codexでは `<leader>om`、回答画面では `Alt-a` が操作の入口になる。
メニューには作業ディレクトリを表示し、追加依頼・差分・未保存ファイル・検証を選べる。

1. `<leader>od` で作業プロジェクトの差分を開く。`q` で戻り、定義・参照・周辺コードから変更の意図を確認する。
2. `<leader>oi` で同じプロジェクトの未保存ファイルを開き、必要な修正を行う。確認した内容を `Ctrl-S` で保存する。
3. `<leader>ov` でプロジェクトの検証コマンドを入力する。下側の端末で実行場所・コマンド・出力・終了コードを確認する。
4. 問題が残れば `<leader>ou` で同じ会話に追加依頼を書く。出力を選択して `<leader>os` で送ることもできる。
5. ステージした差分を `<leader>gV` で確認し、既存のGit操作でコミットする。

検証はディスク上のファイルを対象にする。未保存内容は自動保存せず、端末は成功時も
残す。`q` で隠し、バッファ一覧から再表示できる。次の実行は新しい端末を使う。
結果はその実行の記録であり、その後の編集を含む作業ツリーの合格を示すものではない。
最終確認ではエージェントの書き込みが終わってから保存・検証・差分確認を行う。

Codexの差分・未保存一覧・検証は、実行中セッションの作業ディレクトリを使う。
別プロジェクトへ移動しても対象は変わらない。起動前は現在のファイルから解決した
ルートを使う。名前のないバッファはプロジェクトを特定できないため、未保存一覧には含まれない。
全バッファの未保存一覧は `<leader>fm`。詳細は [Codexの操作](keymaps.md#codex-leadero-prefix) を参照。

## 全体の設計

| 担当 | この環境での役割 |
| --- | --- |
| エージェントCLI / ACP | 依頼された実装と調査。Neovimから会話を開き、コードや出力を渡す |
| Neovim | 定義・参照の理解、差分レビュー、局所的な修正、診断と検証結果の確認 |
| Git / worktree | 変更・ステージ・履歴の管理。並行タスクは別worktreeに分ける |
| Fish / 端末 | プロジェクトへの移動、CLI起動、反復実行。手順は [Fishの作業案内](../fish/README.md#agent-assisted-workflow) |
| プロジェクトのAGENTS.md / CI | プロジェクト固有の検証コマンドと完了条件。dotfilesには一律のテストコマンドを埋め込まない |

CodeDiffには同じworktreeの既存変更も含まれる。エージェントだけが作った差分とは
区別できないため、別タスクは作業ディレクトリを分ける。CLIが動いていること、
回答が表示されたこと、診断がゼロであることも、それぞれ検証の成功とは分けて判断する。
Signalboxは継続中のエージェントの状況確認に使う。

通常のファイル・本文検索はTelescope、構造化した一覧はSnacks、LSP補完はBlink、
インライン提案はCopilot。Televisionはquickfixの絞り込みと明示的なGit変更一覧に使う。
CodeDiffで作業中の差分、Diffviewで履歴や競合、Gitsignsで編集中の変更箇所を扱う。
新しいプラグインは、こうした既存の担当では足りない操作があるときに追加する。

## オプションの方針

エージェントと並行して編集するときは、保存済みファイルと未保存バッファを区別し、
変更を確認してから保存する。2026-10-27に導入済みLazyVimの既定値と照合し、
必要な上書きだけを `config/options.lua`、ファイル種別ごとの表示を `config/autocmds.lua`、
診断と描画をそれぞれ `plugins/lsp.lua` / `plugins/ui.lua` に整理した。

| 領域 | この環境の動作 | 設定の持ち方 |
| --- | --- | --- |
| 保存と外部変更 | 通常のファイルは明示的に保存。エージェントによる変更は再読込・マージし、未保存編集を保つ | `autowrite=false` を上書き。`autowriteall=false`、`autoread=true`、`confirm=true`、`undofile=true` は既定値を継承 |
| コードと文章 | コードは折り返さず、文章は画面幅で折り返す。行番号・インデントを保ち、折り返しだけでファイル内容は変えない | `wrap=false` はLazyVimに任せ、文章系のFileTypeで有効化。`breakindent=true`、`scrolloff=8` は独自設定 |
| 入力と検索 | 補完・検索・置換で既存の操作を共有し、置換は確定前にプレビュー | `ignorecase` / `smartcase`、番号表示、インデントは既定値を継承。`inccommand=split` と `ai_cmp=false` を上書き |
| 診断と状態 | 診断の詳細は現在行、左端は重要度の印、右下は未保存・エラー・警告の件数を表示 | `virtual_text=false` / `virtual_lines.current_line=true` を指定。sign・下線・重要度順・入力中の更新抑制はLazyVimに任せる |
| 画面と応答 | コードと端末の表示領域を確保し、入力待ち時間や更新頻度は既定値を維持 | `laststatus=0` / `cmdheight=0` / `winborder=rounded` を上書き。分割方向・位置保持、`timeoutlen=300` / `updatetime=200` は継承 |

### 保存のタイミング

LazyVimの `autowrite=true` は、`:!` で外部コマンドを実行するときなどに
未保存内容を書き出す。この環境では無効にし、`:w` / `Ctrl-S` で保存する。
通常の保存時の整形は維持し、`<leader>uf` で切り替える。
quickfixの編集も `edit.autosave=false` のまま、元バッファを確認して保存する。

`autoread` は外部変更の読込であり、自動保存とは別。外部変更のマージ結果は未保存の
まま保持する。永続UndoはLazyVimの設定を利用し、swapfileは従来どおり無効にする。
永続Undoは、異常終了時に未保存内容を回復するswapfileの代わりにはならない。

### ファイル種別ごとの表示

`markdown` / `text` / `gitcommit` / `plaintex` / `typst` は折り返しを有効にし、
日本語向けに自動スペルチェックを無効にする。コードは折り返さず、必要なウィンドウだけ
`<leader>uw` で切り替える。FileTypeの初期設定だけを行い、バッファへ戻るたびに
手動の切り替えをリセットしない。プラグインの特殊バッファは各プラグインに任せる。
Markdownの整形も `--prose-wrap never` のまま、画面上の折り返しと保存内容を分ける。

診断を一時的に隠す操作は `<leader>ud`、インレイヒントは `<leader>uh`、
スペルチェックは `<leader>us`。Rustの型ヒント・CodeLensは維持する。
診断表示を消しても、エラーそのものが解消されたわけではない。

キー待ち時間や更新頻度を短くする変更は、実際の遅延や負荷を測ってから判断する。
これらの値は上流の更新で変わる可能性があるため、更新時に実効値を確認する。
オプションの意味は [Neovimの公式ヘルプ](https://neovim.io/doc/user/options/) を参照。

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
| ファイル・本文検索 | Telescope        | ルート・cwdを指定した検索とプレビュー |

### incline.nvim 表示内容

- ファイルアイコン（filetype色）
- ファイル名（汎用名は親ディレクトリも表示: `plugins/init.lua`）
- 未保存マーク（オレンジの丸）
- 診断数（`E2` はエラー2件、`W1` は警告1件）
- 非アクティブ時は薄く表示

## ディレクトリ構成

```
nvim/
├── init.lua                    # エントリポイント: require("config.lazy")
├── .stylua.toml                # Luaフォーマッター設定
├── lazy-lock.json              # lazy.nvim plugin revision lockfile
├── lazyvim.json                # LazyVim metadata
├── README.md                   # 操作・構成・検証
├── keymaps.md                  # 操作とキーの一覧
├── maintenance.md              # 更新・不具合調査・分離環境での検証
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
        ├── navigation.lua      # Telescope, Snacks, Television, fff, oil, overlook, treewalker, hbac
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

日常の作業では検索とレビューを優先する。Terraformの言語支援は必要なファイルを
開くときのために残し、専用のドキュメント・state検索は補助機能として扱う。

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

mini.alignは表や代入文の整列、multicursor.nvimは選んだ単語だけの同時編集を補う。
どちらも初回のキー操作で読み込む。Telescopeは通常のファイル・本文検索を担当し、
`<leader><leader>` / `Ctrl-P` / `<leader>ff` でファイル、`<leader>/` / `<leader>sg` で
本文を検索する。`<leader>sR` で直前のTelescope検索を再開する。
fffは入力ミスを許容する検索として残す。Fishとquickfixで使う
[Televisionの操作](../television/README.md)は別にまとめる。

採用理由、Star数と伸びの測定時点は [調査記録](plugin-research.md)にまとめる。
過去のAPI移行や互換性修正は [設定の確認記録](plugin-config-review.md)に残し、
現在の操作は [キーマップ](keymaps.md)、更新時の注意点は [メンテナンス](maintenance.md)で管理する。

| 追加 | 理由 |
| --- | --- |
| `kevinhwang91/nvim-bqf` | quickfix の preview / filter / split open を補強する。既存の Trouble や Snacks picker とは用途が違う |
| Snacks.gitbrowse (`what = "permalink"`) | 現在行や選択範囲の permalink を `<leader>gY` でコピー、`<leader>gB` でブラウザ表示。gitlinker.nvim は LazyVim 既定のこの機能で置き換えた |

## インストール

```bash
# 既存の別設定はlink.shがバックアップしてからリンクする
cd ~/ghq/github.com/nwiizo/dotfiles
rtk proxy ./scripts/link.sh

# Neovim起動（プラグイン自動インストール）
rtk proxy nvim
```

`lazy-lock.json` はlazy.nvim公式推奨どおりバージョン管理する。別マシンでは `:Lazy restore` でlockfileのrevisionへ復元できる。`:Lazy update` によるrevision更新は、関連する設定変更と一緒にレビュー・コミットする。

既存の設定変更はNeovimを再起動して反映する。検証方法とローカルプラグインの
ビルド手順は [メンテナンス](maintenance.md)を参照。

## 要件

- Neovim 0.12+
- Node.js (Copilot, Mason)
- Rust toolchain (rust-analyzer)
- Go toolchain (gopls)
- lazygit (LazyGit統合用)
- ripgrep (Snacks picker)
