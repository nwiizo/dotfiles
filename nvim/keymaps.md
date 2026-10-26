# Neovimの操作とキーマップ

[全体像と日常のレビュー](README.md) · [メンテナンス](maintenance.md)

`<leader>` はSpace。Normal・Insert・Visual・Terminalはそれぞれ `n`・`i`・`x`・`t`。
機能名を探すときは `<leader>` のwhich-key、Telescopeの検索機能は `<leader>fT`、
Snacksの一覧は `<leader>sP`、
Codexでの次の操作は `<leader>om` を使う。

> `L` = LazyVim提供、`C` = カスタム、`P` = プラグイン提供

## 基本操作

| キー        | モード | 説明               | 出典            |
| ----------- | ------ | ------------------ | --------------- |
| `;`         | n      | コマンドモード     | C               |
| `jk` / `jj` | i,c,t  | ESC（遅延なし）    | P better-escape |
| `jk` | x,s | 選択モードを終了 | P better-escape |
| `<C-s>`     | n,i,x  | 保存               | L               |
| `<Esc>`     | n      | 検索ハイライト消去 | L               |

## ナビゲーション

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

## ファイル・プロジェクト

| キー | モード | 説明 | 出典 |
| --- | --- | --- | --- |
| `<leader><leader>` | n | ファイル検索（ルート） | C Telescope |
| `<leader>fp` | n | Projects（ghq配下と最近開いたリポジトリ） | P Snacks |
| `<leader>fm` | n | 未保存バッファ一覧（現在のバッファも含む） | C Snacks |
| `<leader>/` | n | 本文のlive grep（ルート） | C Telescope |
| `<leader>ff` / `<leader>fF` | n | ファイル検索（ルート / cwd） | C Telescope |
| `<leader>fc` | n | Neovim設定ファイルの検索 | C Telescope |
| `<leader>fn` | n | 新規ファイル | L |
| `<C-p>` | n | ファイル検索（ルート） | C Telescope |
| `<leader>fP` | n | 入力ミスを許容するファイル検索（ルート） | C fff |
| `<leader>fT` | n | Telescopeの検索メニュー | P telescope |
| `-` | n | Oil ファイルエクスプローラ | P oil |
| `<leader>e` | n | Oil ファイルエクスプローラ | P oil |

Telescopeの他の検索機能は `<leader>fT` または `:Telescope` から選ぶ。
native sorterを併用し、`version = "*"` で選んだリリースをlockfileに記録する。

## 検索 (`<leader>s` prefix)

通常のファイル検索とlive grepはTelescopeを使う。隠しファイルも対象にし、
Gitの内部ファイルとignore対象は除外する。live grepは入力をripgrepの検索式として渡す。
ルート検索とcwd検索を分け、エディタ自体のcwdは変更しない。
入力ミス補正やplain / regex / fuzzyの切り替えはfff、診断・LSPなどの一覧はSnacksを使う。

Telescopeでは `Ctrl-N/P` で移動、`Enter` で開き、`Ctrl-X/V/T` で横分割・縦分割・タブに開く。
`Tab` で複数選択し、`Alt-Q` で選択結果をquickfixへ送る。`Ctrl-Q` は検索結果全体を送る。
`Ctrl-C` で閉じる。`Esc` は入力モードからNormalモードへ移り、もう一度押すと閉じる。

| キー | モード | 説明 | 出典 |
| --- | --- | --- | --- |
| `<leader>sg` | n | 本文のlive grep（ルート） | C Telescope |
| `<leader>sF` | n | 内容検索（plain / regex / fuzzy） | C fff |
| `<leader>sG` | n | 本文のlive grep（cwd） | C Telescope |
| `<leader>sq` | n | quickfixを検索して移動 | L Snacks |
| `<leader>sw` | n,x | カーソル下の単語・選択範囲をGrep | L Snacks |
| `<leader>sb` | n | 現在バッファ内の行検索 | L Snacks |
| `<leader>sc` | n | コマンド履歴 | L Snacks |
| `<leader>sh` | n | ヘルプページ | L Snacks |
| `<leader>sk` | n | キーマップ | L Snacks |
| `<leader>sd` | n | 診断一覧 | L Snacks |
| `<leader>ss` | n | LSPシンボル | L Snacks |
| `<leader>sR` | n | 直前のTelescope検索を再開 | C Telescope |
| `<leader>sP` | n | Snacksの検索機能一覧 | C Snacks |
| `<leader>su` | n | Undo履歴のプレビューと復元 | L Snacks |
| `<leader>st` / `<leader>sT` | n | TODO検索（全て / TODO・FIX・FIXME） | L todo-comments |
| `<leader>sy` | n,x | ヤンク履歴 | P yanky |

### Snacks Pickerの標準機能と使い分け

SnacksはLazyVimの標準Picker。
LSP・履歴・診断・Undo・Git操作は標準の連携を使う。fzf本体への依存はない。

Smart Pickerは `<leader>sP` の `smart` から開く。バッファ・最近使ったファイル・プロジェクト内のファイルをまとめ、
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

## バッファ管理

| キー         | モード | 説明               | 出典     |
| ------------ | ------ | ------------------ | -------- |
| `<leader>bd` | n      | バッファ削除       | L Snacks |
| `<leader>bo` | n      | 他のバッファを削除 | L Snacks |
| `<leader>bi` | n      | 表示していないバッファを削除 | L Snacks |
| `<leader>bb` | n      | バッファ切替       | L        |

## LSP

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

## 診断

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

## コードピーク (`<leader>p` prefix)

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

## Git (`<leader>g` prefix)

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

## トグル (`<leader>u` prefix)

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

## ウィンドウ・スプリット

| キー | モード | 説明 | 出典 |
| --- | --- | --- | --- |
| `<leader>\|` | n | 縦分割 | L |
| `<leader>-` | n | 横分割 | L |
| `<leader>w=` | n | スプリット均等化 | C |
| `<leader>wm` | n | ウィンドウ最大化トグル（`<leader>uZ` と同じ） | L Snacks |
| `<C-Up/Down/Left/Right>` | n | ウィンドウリサイズ | L |

## ビジュアルモード

| キー              | モード | 説明                     | 出典 |
| ----------------- | ------ | ------------------------ | ---- |
| `J` / `K`         | v      | 行を下/上に移動          | C    |
| `<A-j>` / `<A-k>` | n,i,v  | 行を下/上に移動          | L    |
| `<leader>P`       | x      | ペースト（レジスタ保持） | C    |
| `<leader>D`       | n,v    | 削除（レジスタなし）     | C    |

## クリップボード・生産性

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

Telescopeで検索結果を `Ctrl-Q`（全体）または `Alt-Q`（選択分）で送ると、quickfix上で本文を編集できる。
閉じた一覧は `:copen` で開く。quickfix内の `:w` は変更を元バッファへ反映し、
ファイルの保存は行わない。`<leader>fm` で変更バッファを確認してから保存する。
ファイル名や行の並びは変えず、本文だけを編集する。

`:%s/旧/新/g` や `<leader>cw` による置換では、入力中に別ウィンドウにも
変更候補を表示する（`inccommand=split`）。Enterで確定、Escで取り消す。

## ターミナル

| キー    | モード | 説明                 | 出典 |
| ------- | ------ | -------------------- | ---- |
| `<c-/>` | n,t    | ターミナルトグル     | L    |
| `<C-x>` | t      | ターミナルモード終了 | C    |

## AIエージェントによる外部編集

エージェントが保存した変更は `<leader>gC` で確認でき、Snacksのステージ・復元操作も使える。`<leader>gT` はTelevisionの `git-diff` チャンネルで、ステージ前後の変更と未追跡ファイルを一覧にする。まとまった差分の確認には `<leader>gd`、ステージ済み差分には `<leader>gs` を使う。

`autoread`と低頻度の`checktime`を利用し、Claude CodeやCodexが保存した未変更bufferは自動的に再読込する。focus/buffer/terminalの切り替えとnormal modeのidle時だけ確認し、カーソル移動ごとのfilesystem確認は行わない。

Neovim側にも未保存の変更がある場合は、バッファを開いた時点の内容を基準に `git merge-file`で3-way mergeする。競合しない変更は両方を保持し、同じ箇所を変更した場合は両方を競合マーカー付きでバッファへ残す。統合結果は未保存のままなので確認後に保存する。ファイル削除時や自動統合できない形式では選択を求める。エージェントへ場所を渡すときは`<leader>yl`で`path:line`形式をclipboardへコピーでき、visual selectionでは行範囲になる。

## セッション (`<leader>q` prefix)

| キー         | モード | 説明                 | 出典          |
| ------------ | ------ | -------------------- | ------------- |
| `<leader>qs` | n      | セッション復元       | L persistence |
| `<leader>ql` | n      | 最後のセッション復元 | L persistence |
| `<leader>qd` | n      | セッション保存停止   | L persistence |
| `<leader>qq` | n      | 全て閉じて終了       | L             |

## AI (`<leader>a` prefix)

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

## Codex (`<leader>o` prefix)

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
| `<leader>oi` | n | 同じプロジェクトの未保存ファイルを確認 | C |
| `<leader>ov` | n | 同じプロジェクトで検証コマンドを入力・実行 | C |
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

`Alt-a` のメニューは、追加依頼・差分・未保存ファイル・検証・その他の操作の5項目。
会話を開く、レビュー依頼を書く、会話を隠す、接続状態と操作説明を見る機能は
「Conversation, review request, and help」から選べる。タイトルに対象ディレクトリを表示する。

日常の順序は [レビューの手順](README.md#日常のレビュー)を参照。
差分は `Alt-d` でも開け、`q` で元のタブへ戻る。
追加依頼は回答画面に直接入力してEnterでも送れる。複数行なら `<leader>ou` を使い、
`Ctrl-S` で送る。端末の表示内容は自動添付しない。
`Alt-q` または `<leader>oh` で編集画面へ戻る。会話は動き続け、`<leader>oo` で再表示できる。

検証コマンドは `:CodexVerify` でも入力できる。現在の `shell` で実行し、未保存内容を
書き出さない。入力をキャンセルすると実行しない。端末上部の `Running` は実行中、
`Exit 0` は正常終了、その他はそのコマンドの終了コード。出力は `q` で隠した後も
バッファ一覧で読めるが、終了コードを含む専用ヘッダーは検証端末のウィンドウに表示する。
ログはNeovim終了後には保存しない。未保存一覧は `:CodexBuffers`、差分は `:CodexChanges` でも開ける。

回答をスクロール・コピーするときは `Esc Esc` でNormal modeへ移り、通常の移動と選択・`y` を使う。`i` でCodexへの入力に戻る。承認や実行中の中断はCodex画面の案内に従う。`<leader>oq` はプロセスの停止なので、単に隠す場合は `Alt-q` を使う。

差分には同じ作業ツリー内の既存の変更も含まれる。Codex経由のEditはファイルを変更する操作で、Avanteの提案パッチとは異なり、後から「採用」を押す方式ではない。ステージ・取り消しはCodeDiffや既存のGit操作で必要な変更だけを選ぶ。

## Codelens

| キー         | モード | 説明         | 出典         |
| ------------ | ------ | ------------ | ------------ |
| `<leader>cc` / `<leader>cC` | n | Codelensを実行 / 更新 | L |

## Rust (`<leader>r` prefix, Rustファイルのみ)

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

## Crates (`<leader>r` prefix, Cargo.tomlのみ)

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

## テスト (`<leader>t` prefix)

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

## デバッグ (`<leader>d` prefix)

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

## リファクタリング (`<leader>R` prefix)

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

