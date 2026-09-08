# Neovimプラグイン調査

調査日: 2026-09-08。対象環境はNeovim 0.12.5、LazyVim 16.0.0。

この構成ではSnacks・Blink・Oilを継続し、`fff`と`codediff.nvim`を追加した。
AIとの並行作業で不足する機能と、既存の操作を保てるかを判断基準にした。
`sidekick.nvim`と`quicker.nvim`は資料調査までの追加候補。

## 人気と開発状況

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

## 今回の設定への反映と検証

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
