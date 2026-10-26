# Neovimプラグイン調査

初回調査: 2026-09-08。最新の確認: 2026-10-27、Neovim 0.12.6。

現在は Snacks・Blink・Oil・fff・CodeDiff・Quicker を使用し、Telescope を追加している。
以下の過去の調査は、その日時点の判断と数値を残したもの。

## 2026-10-27: 整列と複数箇所の編集

公式README、GitHub REST APIの累計Star数・更新日・未解決issueを確認した。
既存の検索、補完、Git、Undo履歴は揃っているため、編集操作を補う2つを導入した。

| 候補 | 累計 Stars | 判断 |
| --- | ---: | --- |
| [mini.align](https://github.com/nvim-mini/mini.align) | 182 | 整列のプレビュー用に追加。既存のmini.aiと同じmini.nvim系列で、系列全体は9,604 Stars。単体の人気と混同しない。 |
| [multicursor.nvim](https://github.com/jake-stewart/multicursor.nvim) | 1,542 | 一致箇所を選んで同時編集するために追加。上流の推奨どおり `1.0` ブランチを使用。 |

両方とも非アーカイブ。mini.alignは安定版 `v0.18.0`、multicursor.nvimは
`c574bfc1f7e63dfea3e64b8453c9f7c660127238`（10月15日の修正）を導入し、
リビジョンを `lazy-lock.json` に記録した。今回のインストール対象はこの2つに限定した。
mini.alignのissueは親リポジトリで管理されており、検索時に整列の互換性を妨げる
未解決issueは見つからなかった。multicursorの未解決issueはnative cursorの提案1件だった。
分離したHOME/XDG環境で、初回キー入力から整列・プレビュー取消・選択した一致箇所の
同時編集・スキップ・Escによる元のキー設定への復帰・Undoが動くことも確認した。

`gA` は整列、Normal/Visualの `Ctrl-N` はカーソル追加、`<leader>cN` は一致箇所の
スキップに割り当てる。標準の `ga` とInsertの `Ctrl-N` は維持する。
上流サンプルの `<leader>s` などは既存グループと衝突するため採用しない。
Undo履歴は既存の Snacks `<leader>su` を使い、別のUndoプラグインは追加しない。

Fishも同時に再調査した。[Fishの選定記録](../fish/README.md#additional-plugins-considered)の
とおり、fzf.fish・doneは既存機能と重なり、replay.fishを必要とするBash専用の設定も
見つからなかったため、導入済みの構成を維持する。

### 人気の伸び

この文書に残っている過去の値と、10月27日にGitHub APIから取得した値を比較した。
累計Star数は利用者数ではなく、増分もNeovim全体のランキングではない。

| 候補 | 比較期間 | Starsの変化 | この環境での位置づけ |
| --- | --- | --- | --- |
| [fff](https://github.com/dmtrKovalenko/fff) | 10月10日→27日 | 11,054→11,180（+126、約1.1%） | 導入済み。`<leader>fP` でファイル検索。Neovim以外のSDKへの関心も含む。 |
| [CodeDiff](https://github.com/esmuellert/codediff.nvim) | 10月10日→27日 | 1,587→1,607（+20、約1.3%） | 導入済み。`<leader>gR` で変更をレビュー。 |
| [Sidekick](https://github.com/folke/sidekick.nvim) | 10月10日→27日 | 2,786→2,801（+15、約0.5%） | 次の編集箇所の提案が候補。既存AI操作とTabの調整が必要。 |
| [sqmeow.nvim](https://github.com/2giosangmitom/sqmeow.nvim) | 9月29日→10月27日 | 136→159（+23、約16.9%） | 未導入。エディタ内でDBを扱いたい場合の候補。CLI側にはrainfrogがある。 |

新作は `topic:neovim-plugin created:>=2026-09-01 stars:>50 archived:false` と
`nvim in:name created:>=2026-09-01 stars:>50 archived:false` の両方で検索した。
[servery.nvim](https://github.com/wurli/servery.nvim) は9月25日作成で74 Stars。
起動中のNeovimセッションをSnacksなどから切り替え、端末を閉じてもセッションを維持する。
Neovim 0.12以上が必要で、稼働時間の表示のみ0.13以上。保存したセッションを復元する
既存のPersistenceとは役割が違うが、常駐するNeovimを管理する使い方は未導入。
過去のStar数がないため、直近の伸び率は断定しない。Star付与日時のAPIは404で取得できなかった。

Fishは `topic:fish-plugin created:>=2026-01-01 stars:>20 archived:false` の検索では
該当なし。topic未設定の候補は含まれず、Fish全体に新作がないという意味ではない。
既存メモのStar数は概数のため、少数の増減を正確な伸びとして扱わない。

## 2026-10-10: Star 数とこの環境への適性

GitHub REST API の `topic:neovim-plugin archived:false` を Star 数順に検索し、
`neovim in:name,description stars:>19812 archived:false` でも上位を確認した。
Neovim 本体・設定一式・リンク集を除き、未導入候補を比較した。
topicや説明文に含まれないプラグインまで網羅した世界順位ではない。

| 候補 | 累計 Stars | この構成での判断 |
| --- | ---: | --- |
| [coc.nvim](https://github.com/neoclide/coc.nvim) | 25,159 | 調査した未導入候補では最多。ただし補完・診断・LSP が Blink と Neovim LSP に重なるため、現在の LazyVim 構成への追加は見送る。 |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | 21,637 | 導入済みのプラグイン管理基盤。 |
| [Telescope](https://github.com/nvim-telescope/telescope.nvim) | 19,812 | Star 数と既存構成との相性を合わせて追加。`<leader>fT` / `:Telescope` から使い、通常の検索キーは維持する。 |

Telescope は公式推奨のリリースタグと native sorter を使用する。
既存の Terraform Extra が提供するドキュメント検索と state 一覧の拡張も有効になる。
日常のファイル・本文検索は Television、構造化した一覧は Snacks、入力ミスを許容する
検索は fff と、使う入口を分けている。

### 2026年の注目候補をどう見るか

2026年の年間 Star 獲得数は取得していないため、累計だけで「今年最もバズった」とは
判断しない。下表の増分は、この文書の9月8日の記録と10月10日の API 値の差。
Neovim 全体の順位や、年間の増加数ではない。

| プラグイン | 累計 Stars / 9月8日からの増分 | nwiizo の構成での評価 |
| --- | ---: | --- |
| [fff](https://github.com/dmtrKovalenko/fff) | 11,054 / +529 | この比較では伸びが最大。導入済みで `<leader>fP` / `<leader>sF` から使える。Neovim以外のSDKも含む数値。 |
| [99](https://github.com/ThePrimeagen/99) | 4,749 / +1 | AIによる検索・作業支援。2026年1月にも[利用方法の議論](https://www.reddit.com/r/theprimeagen/comments/1qs403e/didnt_get_the_idea_behind_99_prompt_plugin/)がある。既存のAI入口と重なり、公式にAPI変更の注意書きがあるため追加しない。 |
| [Sidekick](https://github.com/folke/sidekick.nvim) | 2,786 / +34 | 次の編集箇所を提案する NES は検討価値がある。現在の Copilot LSP と Tab の役割を調整する必要があり、今回は未導入。 |
| [CodeDiff](https://github.com/esmuellert/codediff.nvim) | 1,587 / +38 | 導入済み。AIが保存した差分を確認する日常操作に適している。 |
| [Quicker](https://github.com/stevearc/quicker.nvim) | 1,030 / +3 | 導入済み。Televisionの検索結果を編集し、確認して保存する流れに適している。 |

2026年作成の新作も別に調べた。`nvim in:name created:2026-01-01..2026-10-10
stars:>100 archived:false` の検索では、
[tree-sitter-manager.nvim](https://github.com/romus204/tree-sitter-manager.nvim) が879 Stars、
[haunt.nvim](https://github.com/TheNoeTrevino/haunt.nvim) が322 Stars。
前者は既存の Treesitter 管理と役割が重なる。後者はコードにメモ付きブックマークを
残す用途の候補だが、どちらも今回は導入していない。

## 2026-09-29の追跡調査

GitHub APIで現在のStar数と作成日を取得し、各公式READMEで機能を確認した。
増分はこの文書の9月8日の記録との差で、利用者数やNeovim全体の順位ではない。
新作の探索は `topic:neovim-plugin created:>=2026-08-29 stars:>10` を
Star数順に検索した。topic未設定のリポジトリは含まれない。

| 候補 | 確認できた動き | この構成での判断 |
| --- | --- | --- |
| [fff](https://github.com/dmtrKovalenko/fff) | 10,887 stars、前回から+362 | 導入済み。`<leader>fP` / `<leader>sF` で利用できる |
| [sidekick.nvim](https://github.com/folke/sidekick.nvim) | 2,778 stars、+26。次の編集箇所を提案するNESとAI CLI連携 | NESが候補。既存のCopilot設定・Tab操作と接続を検証してから導入する |
| [review.nvim](https://github.com/georgeguimaraes/review.nvim) | 128 stars。CodeDiffへのコメントをMarkdownとして出力 | AIへレビュー結果を渡す用途に合う。今回は資料調査まで |
| [sqmeow.nvim](https://github.com/2giosangmitom/sqmeow.nvim) | 9月10日作成、136 stars。Rust製エンジンによるSQL実行・結果表示 | 今月の新作として注目。DB接続をエディタ内で扱う必要が生じたら検討 |
| [autodap.nvim](https://github.com/JarnDev/autodap.nvim) | 9月17日作成、23 stars。Node/Python/C/C++のDAP設定を補助 | 新作で検証例が少なく、既存の言語別DAP設定とも重なるため保留 |

CodeDiffも1,579 stars（+30）で、引き続き使用する。
この比較で増加が最も大きかったfffは、Neovim以外のSDK・MCPも含むため、
Star増加のすべてをNeovim利用の増加とは解釈できない。

実際に追加したのは、以前から候補にしていた
[Quicker](https://github.com/stevearc/quicker.nvim)（v1.5.1相当）。
急増中という判断ではなく、既存のTelevision→quickfixの操作に、前後行の表示と
本文編集を追加できる点を評価した。`edit.autosave=false` とし、`:w` で元バッファへ
反映した後に確認して保存する。nvim-bqfのプレビューとTelevisionの絞り込みは併用する。
Neovim標準の `inccommand=split` も有効にし、置換の入力中に画面外の候補を確認できるようにした。

`tests/quickfix_editing.lua` で前後行の展開・折りたたみ、複数バッファへの編集反映、
未保存編集とディスク内容の保持を確認する。新作候補の実行やDB接続は行っていない。

## 2026-09-08: 人気と開発状況

[GitHub TrendingのLua月間欄](https://github.com/trending/lua?since=monthly)では、
取得時点でLazyVim、lazy.nvim、nvim-lspconfig、conform.nvimが掲載されていた。
これらはすでにこの環境で使っている。以下の比較は、その基盤に関連する
人気プラグインと追加候補を対象にしたもので、月間ランキングではない。

Star数と最終push日はGitHub REST APIのリポジトリ情報から取得した。
Star数は注目度の目安で、利用者数や品質の測定値ではない。最終pushには
文書・タグなどの更新も含まれ、更新間隔だけで保守終了とは判断しない。
下表の全リポジトリは取得時点でアーカイブされていなかった。

| プラグイン | Star数 | 最終push日（UTC） | この環境での判断 |
|---|---:|---|---|
| [fff](https://github.com/dmtrKovalenko/fff) | 10,525 | 2026-09-08 | 導入。Rustによる入力ミスに強いファイル・内容検索。Telescopeと専用キーで使い分ける |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | 8,073 | 2026-05-25 | 導入済み。検索・ターミナル・Git操作の共通基盤として継続 |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | 6,883 | 2026-06-02 | 導入済み。バッファのようにファイルを操作する用途を継続 |
| [blink.cmp](https://github.com/saghen/blink.cmp) | 6,561 | 2026-09-06 | 導入済み。補完エンジンの追加は不要 |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | 5,805 | 2024-08-02 | 導入済み。現行操作を保ちつつ、CodeDiffとの比較対象にする |
| [99](https://github.com/ThePrimeagen/99) | 4,748 | 2026-06-12 | AIによる検索・作業支援。ベータ版でAPI変更の注意書きがあり、経過を見る |
| [opencode.nvim](https://github.com/nickjvandyke/opencode.nvim) | 3,815 | 2026-08-21 | OpenCodeを主に使う場合の候補。現在のClaude/Codex中心の構成とは重複が多い |
| [claudecode.nvim](https://github.com/coder/claudecode.nvim) | 3,047 | 2026-09-03 | 導入済み。Claude Code専用の接続と差分確認を継続 |
| [sidekick.nvim](https://github.com/folke/sidekick.nvim) | 2,752 | 2026-04-22 | 次の編集箇所を提案するNESが追加価値。CLI用ターミナルは既存機能と重なる |
| [codediff.nvim](https://github.com/esmuellert/codediff.nvim) | 1,549 | 2026-09-07 | 導入。エージェントの変更を継続的にレビューする画面。Diffviewは従来のキーで利用できる |
| [quicker.nvim](https://github.com/stevearc/quicker.nvim) | 1,027 | 2026-05-24 | quickfix内の直接編集が必要になったときの候補。nvim-bqfとの併用に対応 |

更新時は、例えば次のコマンドで同じ項目を取得できる。

```sh
rtk proxy gh api repos/esmuellert/codediff.nvim \
  --jq '{repository: .full_name, stars: .stargazers_count, archived: .archived, pushed_at: .pushed_at}'
```

## 追加候補の比較

### fff: ファイル名と内容の曖昧検索

[fff](https://github.com/dmtrKovalenko/fff)はNeovimプラグインに加え、検索SDKや
MCPサーバーも含む。今回導入するのはNeovim側の検索機能。
利用頻度を考慮した順位付けと、ファイル名・内容の入力ミスを許容する検索を備える。
ファイル検索は `<leader>fP`、内容検索は `<leader>sF` に割り当てた。

選定したリリースは[v0.10.6](https://github.com/dmtrKovalenko/fff/releases/tag/v0.10.6)。
lazy.nvimの `version = "*"` では、数字だけのコミットタグ `7298978` が選ばれたため、
`version = "^0.10.6"` に絞った。リビジョンはlockfileで固定し、リリースに対応する
ネイティブライブラリをビルド手順で取得する。
公開ベンチマークの速さをこの環境の測定値として扱わず、検索結果と画面操作を確認する。

### CodeDiff: AIが変更を続ける間の差分確認

[CodeDiff](https://github.com/esmuellert/codediff.nvim)は、リポジトリの変化に追従する
レビュー画面、左右分割・インライン表示、文字単位の強調、部分的なステージ操作、
履歴・競合解消を備える。最新の公開リリースは
[v4.0.2（2026-09-07）](https://github.com/esmuellert/codediff.nvim/releases/tag/v4.0.2)。
初回利用・更新時に対応するネイティブライブラリと変更監視用の実行ファイルを
ダウンロードする。今回の環境では `libvscode-diff 4.0.2` と
`codediff-watcher 0.23.2` を取得した。

現在のDiffviewは、GitHub API上の最終pushが2024-08-02だった。
これだけで動作不良や保守終了とは言えないが、新しいレビュー機能を比較する理由にはなる。
既存の `<leader>gd`、`<leader>gs`、履歴表示、3-wayの競合操作を対応付け、
未保存バッファと外部編集を同時に扱う動作を確認してから置き換える。
並行して使う場合も、試用コマンドを分けて既存キーとの衝突を避ける。

### Sidekick: カーソル位置の補完から次の編集提案へ

[Sidekick](https://github.com/folke/sidekick.nvim)のNES（Next Edit Suggestions）は、
同じファイル内の複数行の変更を提案し、変更箇所へ移動して適用する機能。
現在のCopilotの入力補完を補う用途がある。最新の公開リリースは
[v2.3.0（2026-03-20）](https://github.com/folke/sidekick.nvim/releases/tag/v2.3.0)。
NESにはCopilotの利用環境が必要で、CLI連携だけの利用とは条件が異なる。

導入済みLazyVimには `ai.sidekick` Extraがある。ただし現在の `ai.copilot` Extraは
copilot.luaを使い、通常のLSP設定側では `copilot.enabled = false` にしている。
Extraの追加だけで動作すると見なさず、Copilot LSPの接続方法を確認する。
`Tab`のスニペット移動とNES適用、既存のAvante・Claude用キーも整理が必要。
CLI画面を増やすより、まずNESだけを評価するのがこの構成には合う。

### Quicker: quickfixの検索結果を編集へつなぐ

[Quicker](https://github.com/stevearc/quicker.nvim)は、検索結果の構文強調、前後の行の表示、
quickfixバッファを編集して `:w` で複数ファイルへ反映する機能を持つ。
最新の公開リリースは
[v1.5.1（2026-05-24）](https://github.com/stevearc/quicker.nvim/releases/tag/v1.5.1)。
公式READMEはnvim-bqfとの併用を案内しているので、プレビュー機能の単純な置き換えではない。

今の構成ではnvim-bqfでプレビュー、Troubleで診断、grug-farで検索置換ができる。
検索結果を通常のバッファ操作で直す使い方が必要なら追加する価値がある。
試用時は、複数ファイルへの書き戻しと、同時にエージェントが保存した場合の扱いを確認する。

## 2026-09-08の設定への反映と検証

fffとCodeDiffは専用キーで利用でき、TelescopeとDiffviewの操作は継続できる。
Telescopeの設定をLazyVimへマージするよう修正し、Trouble・Flash連携を復旧した。
Snacksの変更ファイル一覧を `<leader>gC` に追加し、AIが保存した変更を確認しやすくした。
同じ値だったNeovim・LazyVimのオプション指定も削除した。

構文・起動確認に加え、Telescopeの連携キーと設定値、変更ファイル一覧を開いて
別ディレクトリの変更が表示されることを確認した。

fff v0.10.6では `navigatoin.lua` から `navigation.lua` が見つかり、内容検索と
両方の検索画面の開閉を確認した。検証時、画面の初期化前に
`file_search(..., { wait_for_index_ms = 10000 })` を呼ぶと、Lua側の初期化状態が
揃わず即座にタイムアウト扱いになる経路があった。通常の画面操作後は同じ待機付き
APIも成功した。今回のキーは画面を開くAPIを使う。

CodeDiff v4.0.2では変更一覧と左右の差分を含む3ペインの表示を確認した。
長時間の変更追従、競合解消、検索速度の比較、AI応答品質は測定していない。
