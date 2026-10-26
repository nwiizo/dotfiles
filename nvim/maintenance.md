# Neovimのメンテナンス

[全体像と設計](README.md) · [キーマップ](keymaps.md)

設定変更は新しく起動したNeovimに反映される。リポジトリのルートで検証する。

## バージョン更新

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

## ネイティブライブラリと既存の調整

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

## 検証

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
変更に関係するものを選び、編集したテストファイルにも `stylua --check` を実行する。

| 変更対象 | `nvim/tests/` 内のテスト | 確認する動作 |
| --- | --- | --- |
| 保存・表示オプション | `editor_options.lua` | 外部コマンド・移動で自動保存しない、明示保存、コードと文章の折り返し、手動切り替えの保持 |
| 通常のファイル・本文検索 | `search_workflow.lua` | Telescopeの初回キー、ルート・cwd・設定ディレクトリ、隠しファイルとignore、ファイル選択、live grep、再開 |
| 整列・複数箇所の編集 | `editing_plugins.lua` | 初回キーからの読み込み、整列と取消、複数編集・スキップ・Esc・Undo |
| プレビュー・ファイル操作 | `navigation_plugins.lua` | Overlookのプレビュー・復元・分割、Oilの外部変更追従・未保存編集の保持。LSP応答だけを置き換える |
| モード切り替え | `escape_modes.lua` | 起動後最初のVisual選択、Select・Insertでの `jk` |
| リファクタリング | `refactoring.lua` | Normal・Visualのデバッグ出力追加、元のコードと既存の `print` を残す全体削除 |
| quickfix編集 | `quickfix_editing.lua` | 遅延読み込み、前後行の展開・折りたたみ、既存キーの共存、複数バッファへの反映と未保存内容の保持 |

AI共通キーとYankyの変更は `keymap_conflicts.lua` で確認する。
Claude Code・CopilotChatを先に読み込み、Avanteによる上書きがないこと、停止と更新の
呼び分け、Visualのヤンク履歴を実キー入力で検証する。AIへの実処理だけを置き換える。

`nvim/tests/codex_workflow.lua` も通常は上記の分離環境で実行する。
選択からEdit・送信・回答・追加依頼・CodeDiff・編集への復帰に加え、
プロジェクト内の未保存ファイルの選択、検証の実行場所、失敗・成功時の出力保持、
未保存編集の保持、入力キャンセルを確認する。
インストール済みプラグインとテスト用ターミナルを使う。
実サービスの確認を明示的に依頼された場合だけ、通常の認証環境で
`rtk proxy env CODEX_NVIM_REAL_CLI=1 nvim --headless -i NONE -u nvim/init.lua '+lua dofile("nvim/tests/codex_workflow.lua")'`
を使う。一時リポジトリ内でファイル変更と追加依頼の2ターンを実行するため、通常の回帰テストとは分ける。

API の移行時は対象操作を実行した後の `:checkhealth vim.deprecated`、Treesitter の
更新時は `:checkhealth nvim-treesitter` も確認する。`:checkhealth which-key` はキーの
重複確認を補助するが、同じキーの上書きは残らないため、読み込み順の回帰テストも使う。
ルールを編集した場合は `rtk proxy ./scripts/audit-agent-config.sh` で参照とリンクを検証する。

## 保守コマンド

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

