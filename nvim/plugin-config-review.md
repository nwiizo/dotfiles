# プラグイン設定の確認

日付ごとの確認・修正の記録。現在の設計は [README](README.md)、操作は
[キーマップ](keymaps.md)、再検証の手順は [メンテナンス](maintenance.md)を参照。
以下の版番号や成功した確認は、各記録の日付時点のもの。

## 2026-10-27: 理解・レビュー・修正を中心にする

エージェントに実装を任せ、人が差分とコードを理解して修正する使い方に合わせた。
検索の優先度を見直し、通常のファイル検索・live grep・検索の再開はTelescopeに割り当てた。
Snacksは診断・LSP・未保存一覧・エージェントの操作メニュー、TelevisionはFishと
quickfixの絞り込みを担当する。Terraformの言語支援は残し、専用拡張を日常操作の中心には置かない。

Codexの操作メニューから作業ディレクトリの差分・未保存ファイル・検証コマンドへ移れる。
検証結果は実行場所・コマンド・終了コードとともに確認し、後続の編集まで合格扱いしない。
暗黙の保存を止め、文章とコードの折り返しを分け、診断の印と未保存マークを見えるようにした。

`search_workflow.lua` は検索範囲・隠しファイル・ignore・選択・再開を実操作で確認する。
`codex_workflow.lua` はテスト用端末を使い、既存の会話・差分操作と新しい未保存一覧・検証を確認する。
保存と表示は `editor_options.lua`、診断と整形は `plugin_config.lua` で確認する。
実行方法は [メンテナンス](maintenance.md#検証)に集約した。

## 2026-10-10: LazyVim v16・キー競合・保守ルール

lockfile と導入済み LazyVim は、確認開始時から
[v16.0.1](https://github.com/LazyVim/LazyVim/releases/tag/v16.0.1)
（`999700997f72227187d49d8b92667183dc7fc809`）だった。
v16.0.1 の nvim-lint / TypeScript 修正は上流の設定を利用する。
[v16.0.0](https://github.com/LazyVim/LazyVim/releases/tag/v16.0.0) の refactoring.nvim v2 対応は
既存設定に入っていたが、実際のキー入力から追加の問題を見つけた。

| 対象 | 再現した問題と修正 |
| --- | --- |
| Avante | 更新と停止が `aS` を共有し、読み込み順によって `an` が Claude の差分拒否から Avante の新規質問に上書きされた。自動登録を止めて lazy.nvim の `keys` に集約。更新 `aS`、停止 `aX`、新規質問 `aN` を分けた。 |
| Yanky | 旧 `<leader>p` の無効化が Normal のみで、Visual に残っていた。`n` / `x` の両方で無効にし、履歴 `<leader>sy` も両モードから使えるようにした。 |
| Refactoring | `<leader>Rc` が返す `g@ag` で mini.ai の `ag` が展開されず、出力を削除できなかった。`remap = true` を加え、バッファ全体を対象にする。 |
| 文書・ルール | `AGENTS.md` に編集方針と環境固有の制約を集約し、`CLAUDE.md` は相対シンボリックリンクにした。README は操作・検証を説明し、ルートの AGENTS と add-config の参照先も統一した。 |

Star 数とこの環境への適性を調べる依頼に合わせ、Telescope v0.2.2 を追加した。
native sorter と、既存の Terraform Extra から有効になる2つの拡張も導入している。
`<leader>fT` / `:Telescope` を専用の入口にし、Television のキーと Snacks の標準 picker を維持。
この確認での lockfile 変更は Telescope 関連の4件の追加だけで、既存リビジョンは維持した。
比較の対象・Star 数・採用理由は [プラグイン調査](plugin-research.md)に記録した。

### 検証

HOME と XDG を分離し、導入済みプラグインを使って実行した。
`keymap_conflicts.lua` と `refactoring.lua` は修正前の失敗を再現してから修正を確認した。
後者では、変数・位置・Visual 選択のデバッグ出力を追加し、元のコードと既存の `print` を
残したまま全体削除できることを確認している。

Telescope はファイルの選択・実際のファイル表示、`fT` のメニュー、native sorter と
Terraform 拡張の読み込み、既存の検索キーを確認した。
Telescope・Treesitter・which-key のヘルスチェックと、使用した経路の非推奨 API チェックが成功。
StyLua、lockfile の JSON 検査、headless 起動、`git diff --check`、エージェント設定の監査も成功。
`plugin_config.lua` と、テスト用ターミナルを使う `codex_workflow.lua` の回帰確認も通った。
Terraform の実 state 操作、全プラグインの全操作、認証済み AI リクエストは対象外。

## 2026-10-10: 配置と標準設定の整理

Neovim 0.12.5 の設定を読み、導入済みの LazyVim / lazy.nvim と公式資料を照合した。
有効なプラグイン定義は、整理前後とも依存とローカル開発分を含めて80件。
用途と設定箇所を追いやすくする変更を選び、プラグインのリビジョンは維持した。

| 対象 | 変更と根拠 |
| --- | --- |
| 設定の配置 | better-escape・surround・mini.ai・matchup・autopairs を `ui.lua` から `coding.lua` へ移動。読み込み条件とキーは維持。[LazyVim は機能別の spec 分割をサポートする](https://www.lazyvim.org/configuration/plugins)。 |
| プラグインの初期化 | modes・vimade・Diffview は `opts` から初期化。Incline も設定値を `opts` へ分け、`config` には初期化と Signalbox の更新イベントを残す。Cargo の冗長な `config = true` と、現行実装で使われない `float_window` を削除。[lazy.nvim が `opts` を `setup()` に渡す](https://lazy.folke.io/spec#spec-setup)。 |
| 標準機能との重複 | nvim-ts-autotag の追加 spec を削除し、[LazyVim 標準の `LazyFile` 読み込み](https://www.lazyvim.org/plugins/treesitter#nvim-ts-autotag)を使用。Mason の追加ツールは既存のリストへ結合し、重複除去を導入済みの `LazyVim.dedup()` に任せる。 |
| Neovim API | Gitsigns のバッファ限定キーを `buffer` から `buf` へ変更。導入済み Neovim の `:help deprecated-0.12` と[非推奨 API 一覧](https://neovim.io/doc/user/deprecated.html)に合わせた。 |
| README | Docker・TOML・Git Extras の記載漏れを補完。TypeScript は vtsls、Rust テストは rustaceanvim.neotest と実態に合わせ、読み込み方とローカル開発プラグインの配置条件を追記。 |

### 重なりがある機能の判断

| 機能 | 現在の使い分け |
| --- | --- |
| 検索 | Television は通常のファイル・本文・quickfix検索、Snacks は LSP・Git・プロジェクト一覧、fff は入力ミスを許容する検索。用途別の既存キーを保つ。 |
| Git | CodeDiff は作業中の変更確認、Diffview は履歴と競合処理、Gitsigns は編集中の hunk 操作。 |
| quickfix | Quicker は検索結果の編集、bqf はプレビューと分割表示、Trouble は診断の一覧表示。Quicker の自動保存無効を保つ。 |
| AI | Copilot の補完、チャット・ACP・CLI の各入口、Signalbox の稼働状況表示を保つ。利用頻度のデータがないため、似た画面という理由で削除しない。 |
| アイコン | LazyVim の mini.icons と各プラグインの devicons 依存がある。互換レイヤーの読み込み順と表示への影響があるため、依存削除を今回の整理には含めない。 |

Oil の起動時読み込みは[公式推奨](https://github.com/stevearc/oil.nvim#installation)に従う。
AI 連携には選択ヒント、外部接続、状態監視の初期化があるため、キーの指定だけを根拠に
`VeryLazy` を除去しない。`dir` で参照する4つのローカルプラグインは各リポジトリで管理する。

### 検証

HOME と XDG ディレクトリを分離し、設定のコピーと導入済みプラグインで確認した。

- StyLua、lockfile の JSON 検査、headless 起動、`git diff --check` が成功。
  Mason の導入対象は整理前の一覧と一致し、lockfile の内容も作業開始時から変わっていない。
- 既存の `plugin_config.lua`、`escape_modes.lua`、`navigation_plugins.lua`、
  `quickfix_editing.lua` が成功。Avante の初期化、診断件数、Ruff 整形、Escape、
  Oil / Overlook、quickfix 編集と未保存内容の保持を確認した。
- キー入力で Surround の囲み操作、括弧補完、新規 HTML バッファの閉じタグ補完を確認。
  modes / Vimade の読み込み・再描画と Signalbox 更新時の Incline 再描画も実行した。
- Gitsigns のバッファ限定キーと hunk プレビュー、Diffview の開閉を確認。
  `:checkhealth vim.deprecated` では、この検証で使った経路に非推奨 API の警告はなかった。
- Cargo はローカルのネイティブライブラリが未ビルドだったため、既存の
  `cargo build --locked --release` を実行。ライブラリの読み込みとコマンド登録が成功した。
  Cargo プラグインのソースや依存バージョンは変更していない。

全プラグインの全操作や、AI サービスへの認証済みリクエストは検証対象に含めていない。
変更は新しく起動した Neovim に反映される。

## 2026-09-24: 操作と公開 API の確認

独自設定を加えているプラグインについて、公式ドキュメントと導入済みの実装を照合した。
以下は設定項目・公開 API の確認結果であり、全プラグインの全操作を検証したものではない。
プラグインの一括更新は行っていない。

### 修正・追加

| 対象と公式資料 | 変更と理由 |
| --- | --- |
| [Overlook](https://github.com/WilliamHsieh/overlook.nvim#configuration) | キー操作を `overlook.api` の公開関数へ修正。以前の `overlook.open_definition()` などは存在せず、実際に例外を再現した。現在位置を開く `<leader>pp` を追加。無効だった直下のサイズ・枠指定を取り除き、既定の画面比率と角丸枠を使用する。 |
| [Oil](https://github.com/stevearc/oil.nvim#options) | 分割操作を `actions.select` の `vertical` / `horizontal` オプションへ移行。`watch_for_changes = true` で外部の追加・移動に追従。`natural_order = "fast"` で大きなディレクトリでは自然順ソートを省く。既存のキー割り当ては維持。 |
| [better-escape](https://github.com/max397574/better-escape.nvim#default-configuration) / [LazyVim の読み込み処理](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/init.lua) | Insert・Cmdline・Terminal への初回移行を待つ設定では、最初の Visual 選択で `jk` が効かなかった。`User LazyVimKeymaps` で読み込み、LazyVim の `j` / `k` 設定後に各モードのマッピングを登録する。 |

Oil の監視は未保存編集があると更新を見送る。実際に外部でファイルを追加した状態でも、
Oil 上の未保存の名前変更が保持されることを検証した。
Overlook と Oil の変更には、既存の lockfile の revision が持つ API を使っている。

better-escape は Visual 専用の `x` と Select 専用の `s` を指定した。
以前の `v` は両方に適用されるため `s` と重複していた。
このモードの区別は [Neovim のマッピング一覧](https://neovim.io/doc/user/map/#map-table)に従う。

### 検索・移動・Git

| 公式資料 | 確認した設定と判断 |
| --- | --- |
| [Snacks picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md) / [fff](https://github.com/dmtrKovalenko/fff#readme) | ルート指定、ファイル検索、live grep の入口を確認。用途別のキーを維持。 |
| [Flash](https://github.com/folke/flash.nvim#configuration) / [Treewalker](https://github.com/aaronik/treewalker.nvim#readme) | ラベル・ハイライト設定、移動と交換コマンドを確認。変更不要。 |
| [hbac](https://github.com/axkirillov/hbac.nvim#readme) | バッファ数の上限と表示中バッファを閉じない設定を維持。 |
| [Gitsigns](https://github.com/lewis6991/gitsigns.nvim#readme) | `on_attach`、行 blame、hunk 操作の設定を確認。変更不要。 |
| [Diffview](https://github.com/sindrets/diffview.nvim/blob/main/doc/diffview.txt) / [CodeDiff](https://github.com/esmuellert/codediff.nvim#readme) | ファイル履歴、競合移動、staged diff のコマンドを確認。変更不要。 |

### 補完・編集・言語

| 公式資料 | 確認した設定と判断 |
| --- | --- |
| [Blink](https://cmp.saghen.dev/configuration/keymap) | 使用中の補完キーのアクション名を確認。AI補完との割り当てを維持。 |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs#readme) / [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag#readme) | Treesitter 判定、fast wrap、独立した autotag 設定を確認。変更不要。 |
| [nvim-surround](https://github.com/kylechui/nvim-surround#readme) / [TreeSJ](https://github.com/Wansmer/treesj#readme) / [Refactoring](https://github.com/ThePrimeagen/refactoring.nvim#readme) | 公開された設定・操作の入口を照合。既存の編集操作を維持。 |
| [rustaceanvim](https://github.com/mrcjkb/rustaceanvim#readme) / [crates](https://github.com/Saecki/crates.nvim/wiki/Documentation-unstable) | Rust の tools 設定、crates の LSP と補完設定を確認。変更不要。 |
| [Neotest](https://github.com/nvim-neotest/neotest/blob/master/doc/neotest.txt) | 出力表示と quickfix の open 設定を確認。Trouble への接続を維持。 |

### 表示・診断

| 公式資料 | 確認した設定と判断 |
| --- | --- |
| [Noice](https://github.com/folke/noice.nvim#configuration) / [which-key](https://github.com/folke/which-key.nvim#configuration) | コマンド欄の配置、presets、グループ定義を確認。変更不要。 |
| [modes](https://github.com/mvllow/modes.nvim#readme) / [Vimade](https://github.com/TaDaa/vimade#readme) | ignore と terminal の対象除外を確認。変更不要。 |
| [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf#readme) / [Trouble](https://github.com/folke/trouble.nvim#configuration) | プレビュー枠と自動表示・終了の設定を確認。変更不要。 |

### 検証

Neovim 0.12.5 と導入済みプラグインを使用し、HOME と XDG ディレクトリを分離した。
追加したテストは、修正前に Overlook の存在しない関数呼び出しと Visual の `jk` 失敗を再現する。

- `tests/navigation_plugins.lua`: 定義・現在位置のプレビュー、フォーカス、閉じる・復元、縦横分割、元ウィンドウへの表示。Oil の縦横分割、外部の追加・名前変更への追従、未保存編集の保持。
- `tests/escape_modes.lua`: UI の起動イベントを再現し、最初の Visual 選択、Select・Insert モードでの `jk` をキー入力で検証。
- `tests/plugin_config.lua`: 既存の Avante ライブラリ・ログ、Incline 診断件数、Ruff 整形の回帰確認。

LSP 定義の応答はテスト用に置き換えているため、個々の言語サーバーとの通信確認は含まない。
大きなディレクトリの速度測定は行っておらず、Oil の公式設定の動作に基づく変更である。
