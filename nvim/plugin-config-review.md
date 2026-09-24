# プラグイン設定の確認（2026-09-24）

独自設定を加えているプラグインについて、公式ドキュメントと導入済みの実装を照合した。
以下は設定項目・公開 API の確認結果であり、全プラグインの全操作を検証したものではない。
プラグインの一括更新は行っていない。

## 修正・追加

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

## 検索・移動・Git

| 公式資料 | 確認した設定と判断 |
| --- | --- |
| [Snacks picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md) / [fff](https://github.com/dmtrKovalenko/fff#readme) | ルート指定、ファイル検索、live grep の入口を確認。用途別のキーを維持。 |
| [Flash](https://github.com/folke/flash.nvim#configuration) / [Treewalker](https://github.com/aaronik/treewalker.nvim#readme) | ラベル・ハイライト設定、移動と交換コマンドを確認。変更不要。 |
| [hbac](https://github.com/axkirillov/hbac.nvim#readme) | バッファ数の上限と表示中バッファを閉じない設定を維持。 |
| [Gitsigns](https://github.com/lewis6991/gitsigns.nvim#readme) | `on_attach`、行 blame、hunk 操作の設定を確認。変更不要。 |
| [Diffview](https://github.com/sindrets/diffview.nvim/blob/main/doc/diffview.txt) / [CodeDiff](https://github.com/esmuellert/codediff.nvim#readme) | ファイル履歴、競合移動、staged diff のコマンドを確認。変更不要。 |

## 補完・編集・言語

| 公式資料 | 確認した設定と判断 |
| --- | --- |
| [Blink](https://cmp.saghen.dev/configuration/keymap) | 使用中の補完キーのアクション名を確認。AI補完との割り当てを維持。 |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs#readme) / [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag#readme) | Treesitter 判定、fast wrap、独立した autotag 設定を確認。変更不要。 |
| [nvim-surround](https://github.com/kylechui/nvim-surround#readme) / [TreeSJ](https://github.com/Wansmer/treesj#readme) / [Refactoring](https://github.com/ThePrimeagen/refactoring.nvim#readme) | 公開された設定・操作の入口を照合。既存の編集操作を維持。 |
| [rustaceanvim](https://github.com/mrcjkb/rustaceanvim#readme) / [crates](https://github.com/Saecki/crates.nvim/wiki/Documentation-unstable) | Rust の tools 設定、crates の LSP と補完設定を確認。変更不要。 |
| [Neotest](https://github.com/nvim-neotest/neotest/blob/master/doc/neotest.txt) | 出力表示と quickfix の open 設定を確認。Trouble への接続を維持。 |

## 表示・診断

| 公式資料 | 確認した設定と判断 |
| --- | --- |
| [Noice](https://github.com/folke/noice.nvim#configuration) / [which-key](https://github.com/folke/which-key.nvim#configuration) | コマンド欄の配置、presets、グループ定義を確認。変更不要。 |
| [modes](https://github.com/mvllow/modes.nvim#readme) / [Vimade](https://github.com/TaDaa/vimade#readme) | ignore と terminal の対象除外を確認。変更不要。 |
| [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf#readme) / [Trouble](https://github.com/folke/trouble.nvim#configuration) | プレビュー枠と自動表示・終了の設定を確認。変更不要。 |

## 検証

Neovim 0.12.5 と導入済みプラグインを使用し、HOME と XDG ディレクトリを分離した。
追加したテストは、修正前に Overlook の存在しない関数呼び出しと Visual の `jk` 失敗を再現する。

- `tests/navigation_plugins.lua`: 定義・現在位置のプレビュー、フォーカス、閉じる・復元、縦横分割、元ウィンドウへの表示。Oil の縦横分割、外部の追加・名前変更への追従、未保存編集の保持。
- `tests/escape_modes.lua`: UI の起動イベントを再現し、最初の Visual 選択、Select・Insert モードでの `jk` をキー入力で検証。
- `tests/plugin_config.lua`: 既存の Avante ライブラリ・ログ、Incline 診断件数、Ruff 整形の回帰確認。

LSP 定義の応答はテスト用に置き換えているため、個々の言語サーバーとの通信確認は含まない。
大きなディレクトリの速度測定は行っておらず、Oil の公式設定の動作に基づく変更である。
