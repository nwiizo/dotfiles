# Ponytail 調査結果

確認日: 2026-09-08。
対象は [commit `356918e`](https://github.com/DietrichGebert/ponytail/tree/356918eba965ee1eac64bd3a7f0dd02108350de5)。
この時点の [Codex plugin manifest][manifest] のバージョンは `4.9.0`。
README、6つのスキル、共通フックの設定と主要実装、公開ベンチマークを読んだ。
プラグインの実行とベンチマークの再実行はしていない。

## 何を変えるものか

Ponytail は、AIエージェントが実装方法を選ぶときの指示を配布するプロジェクト。
言語ごとの整形規則や自動リファクタリングではなく、作る量と依存を減らすための
判断順序を、スキル、各クライアント向けルール、プラグインから与える。
ライセンスは MIT。[README][readme] と [本体スキル][skill] に設計意図がある。

中心となる順序は、必要性の確認、コードベース内の再利用、標準ライブラリ、
プラットフォームの標準機能、導入済み依存、ワンライナー、それでも足りない部分の実装。
現在の版は、その前に関連コードと実際の処理経路を読むよう指示している。
不具合では変更する関数の呼び出し元を探し、共通処理に原因があればそこで直す。
入力検証、データ損失を防ぐ処理、安全性、アクセシビリティ、明示された要件は
簡略化で削ってはいけないとしている。[共通ルール][rules]

## 提供するスキル

| 名前 | 役割 | 適用範囲・制限 |
|---|---|---|
| `ponytail` | 実装量を抑える判断を適用する | コード作成、修正、設計、レビュー。lite / full / ultra を持つ |
| `ponytail-review` | 差分から不要な複雑さを探す | 指摘のみ。正しさ、安全性、性能の総合レビューは範囲外 |
| `ponytail-audit` | リポジトリ全体から削除・置換候補を探す | 指摘のみ。差分レビューより対象が広い |
| `ponytail-debt` | `ponytail:` コメントを集める | 制限と見直し条件を一覧化。見直し条件がない箇所も示す |
| `ponytail-gain` | 公開済みベンチマークの数値を表示する | 手元のリポジトリやセッションの削減量を測る機能ではない |
| `ponytail-help` | モードとコマンドの説明 | 説明のみ |

役割は [README][readme]、詳細は [review][review]、[audit][audit]、
[debt][debt]、[gain][gain]、[help][help] で確認した。

`lite` は依頼を実装して簡単な代替案を示し、`full` は判断順序を適用する既定値、
`ultra` は削除や必要性への問い直しを強く求める。`off` も用意されている。
ただし、強度の切り替えは指示文の変更であり、出力の小ささや正しさを機械的に
保証するものではない。[本体スキル][skill] と [指示文の生成処理][instructions]

## 自動適用の仕組み

[共通フック設定][hooks] は次の3イベントを登録している。
README のインストール節には「2つのフック」とあるが、この確認版の設定は3つある。

| イベント | 実装上の動作 |
|---|---|
| `SessionStart` | 既定モードを読み、状態を保存し、そのモードの指示文を追加する |
| `SubagentStart` | 保存されたモードの指示文を子エージェントにも追加する |
| `UserPromptSubmit` | 入力先頭のコマンドや停止表現からモードを変更する |

Node.js で動作する。通常の Claude/Codex 向け処理では開始時に本文を追加し、
モード変更を追跡する。すべてのホストで本文を毎回再送する実装ではない。
Qoder の毎回追加処理は別の分岐になっている。[開始処理][activate] と [モード追跡][tracker]

設定の優先順は環境変数 `PONYTAIL_DEFAULT_MODE`、設定ファイルの `defaultMode`、
既定値 `full`。Claude では `.ponytail-active`、Codex 向け分岐では
`PLUGIN_DATA` 配下に状態を保存する。[help][help] と [状態管理][runtime]

実装を読む限り、Claude のモードファイル名にセッションIDは含まれない。
同じ設定ディレクトリの同時セッションでは、モード切り替えが互いに影響する可能性がある。
これは状態管理コードからの推論で、並行セッションでの再現確認はしていない。

## 公開ベンチマークの読み方

[2026-06-18 の公開結果][benchmark] は、Claude Code と Haiku 4.5 を使い、
FastAPI + React の実リポジトリで12の機能課題を各条件4回実行した比較。
比較対象はスキルなし、Ponytail、短い説明を求める Caveman、短いYAGNI指示の4条件。

| 指標 | Ponytail の報告値（スキルなしとの比較） |
|---|---:|
| 差分の追加行数 | −54% |
| トークン数 | −22% |
| 費用 | −20% |
| 所要時間 | −27% |

日付入力のように標準UIで置き換えられる課題では削減が大きく、すでに小さい処理では
差がほぼない。これは作者による特定条件の測定であり、このスキルやユーザーの
作業で同じ削減率が出ることを示すものではない。

同じ報告には以下の限界も記載されている。

- 機能課題は生成された差分を測る。サーバーやブラウザーを動かす機能確認はしていない。
- 主な比較は1モデル、各4回。4セルでは処理を強制終了し、行数は集計したが費用・時間は除外している。
- 安全性は別課題で生成関数を実行する検査。「100% safe」の内訳は5種類の安全性課題×4回の20件であり、一般的な安全性の保証ではない。
- 旧版の「80–94%削減」は単発応答の比較で、説明文を含む基準側の測り方が削減率を大きく見せていたと作者自身が認めている。

この確認版では、README は新しい結果を主に示す一方、[gain スキル][gain] は
旧版の「行数80–94%減、費用47–77%減、3–6倍高速」を表示する指示のまま残っている。
効果を説明する際は、どの測定条件の値かを分ける必要がある。

[2026-06-22 の追試][comprehension] では、共有処理に原因がある不具合を題材に、
呼び出し元を検索する具体的な指示の効果を検証している。報告された効果はモデルにより異なり、
既存コードの再利用を促す指示については、指示なしでも再利用できたため効果未実証としている。
「良い方針」と「比較で効果が確認された方針」を分けている点は参考になる。

## nwiizo-coding-style の機能対応

6つの機能を一つのスキルから選べる形にする。対応は次のとおり。

| Ponytail | nwiizo-coding-style |
|---|---|
| 本体の lite / full / ultra / off | 同じモード名。会話内で引き継ぎ、`default` で文書の既定値を更新できる |
| `ponytail-review` | `$nwiizo-coding-style review` |
| `ponytail-audit` | `$nwiizo-coding-style audit` |
| `ponytail-debt` | `$nwiizo-coding-style debt`。新旧両方のコメントを集計する |
| `ponytail-gain` | `$nwiizo-coding-style gain`。新しい公開ベンチマークと測定条件を示す |
| `ponytail-help` | `$nwiizo-coding-style help` |

次は、ユーザーの開発方針とモデル向け指針に合わせた運用上の調整。

| 上流の方針・指示 | このスキルでの扱い |
|---|---|
| 既存コード、標準ライブラリ、標準機能を先に検討する | 採用。必要な動作を満たせるかを確認する |
| 呼び出し元を調べ、共通の原因を直す | 採用。呼び出し元ごとの意図的な違いは維持する |
| 安全性や明示された要件は削らない | 採用。互換性、必要な性能・運用要件も考慮する |
| 1行にできるなら1行、ファイル数も最小にする | 読みやすさと責務のまとまりを基準にする |
| 実装が一つのインターフェースや未依頼の抽象化を避ける | 将来だけが理由の抽象化を避ける。現在の境界に役立つ構造まで禁じない |
| 簡単な版を先に出して複雑な依頼を問い直す | 明示された要件を保つ。結果に影響する未決事項だけ確認する |
| 実行できる検証を一つ残し、テスト基盤やfixtureを原則増やさない | 既存の検証基盤と必要な確認範囲を使う。数を固定しない |
| 簡略化の制限を `ponytail:` コメントに残す | `nwiizo-coding-style:` に制限と見直し条件を残し、一覧化では既存の `ponytail:` も読む |
| 出力を最大3行にする | 必要な説明と検証結果を簡潔に示す。固定行数は設けない |
| 自動フックで状態を保存し指示を追加する | 共通ルールからスキルを選択し、モードは会話内で引き継ぐ。外部フックは追加していない |

上流の「話し方は対象外」という説明と「コードの後は最大3行」という出力指示には
緊張がある。また、review の例にある簡易メール判定などは、対象の検証要件を確認せず
そのまま置換案として使わない。[本体スキル][skill] と [review][review]

`nwiizo-coding-style` は実装、レビュー、監査と各操作を受け持つ。
`home-karpathy-guidelines` は結果を左右する前提が未解決なときの整理を受け持ち、
実装方法の判断は前者を参照する。Ponytail プラグインそのものは追加していない。

## Astra の公式指針との対応

2026-09-08 に [GPT-6 Astra の Prompting best practices](https://developers.openai.com/api/docs/guides/latest-model#prompting-best-practices)
を確認した。公式指針は挙動を調整するための例であり、ユーザーの希望に合わせて適用する。

| 公式ガイドの論点 | 今回の指示への反映 |
|---|---|
| 確認待ちで止まりすぎず、依頼の完了まで進める | 実装依頼は適用・検証まで進め、重要な未決事項だけ確認する |
| スキルの強い指示や矛盾の影響を監査する | ユーザー指示の優先を明記し、本文と操作別手順、既存スキルの重複を整理する |
| 文章の長さと構成を指定する | 簡潔な段落を基本とし、比較では表を使う。説明の行数を固定しない |
| 委譲の頻度を利用環境に合わせる | 既存の委譲方針を保ち、許可された委譲では対象・モード・スキルの場所を引き継ぐ |
| 変更の規模に応じて検証を調整する | 必須の検証を完了し、変化や懸念が増えたときだけ拡大・再実行する |

これは文書と指示の整合確認であり、Astra での性能向上を実験した結果ではない。

## Rust のツール確認

`similarity-rs 0.5.0` と `cargo-coupling 0.3.8` が導入済み。
両者のCLIヘルプでオプションを確認し、既存の similarity リポジトリで診断を実行した。
`cargo coupling --version` は未対応のため、バージョンは Cargo の導入記録から確認した。

- `similarity-rs` は指定ソース6ファイルを解析し、類似する関数を5組報告して終了コード0。
- `cargo coupling` は指定した crate の外を含めて78ファイル・55モジュールを解析し、終了コード0。
- `src` を指定しても同じ workspace 全体を解析した。`--no-git` の出力には変更頻度と同時変更の解析を省いたことが明示された。

このため手順には実際の解析範囲を確認すること、同じ workspace を繰り返し解析しないこと、
診断結果の採用は依頼された範囲に絞ることを含めた。表示された重複や結合を不具合とは判定していない。
ツールの仕様は [similarity](https://github.com/mizchi/similarity) と
[cargo-coupling](https://github.com/nwiizo/cargo-coupling) の説明、導入済みCLIの出力を照合した。

解析範囲が広がる挙動は [Issue #86](https://github.com/nwiizo/cargo-coupling/issues/86)
として登録した。修正版のローカルビルドでは同じ crate が6ファイル・6モジュールに
絞られることを確認した。導入済みバイナリの置換や公開は行っていないため、
手順には旧版と修正版の範囲の違いを残している。

[readme]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/README.md
[manifest]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/.codex-plugin/plugin.json
[rules]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/AGENTS.md
[skill]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/skills/ponytail/SKILL.md
[review]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/skills/ponytail-review/SKILL.md
[audit]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/skills/ponytail-audit/SKILL.md
[debt]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/skills/ponytail-debt/SKILL.md
[gain]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/skills/ponytail-gain/SKILL.md
[help]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/skills/ponytail-help/SKILL.md
[hooks]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/hooks/claude-codex-hooks.json
[activate]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/hooks/ponytail-activate.js
[tracker]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/hooks/ponytail-mode-tracker.js
[runtime]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/hooks/ponytail-runtime.js
[instructions]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/hooks/ponytail-instructions.js
[benchmark]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/benchmarks/results/2026-06-18-agentic.md
[comprehension]: https://github.com/DietrichGebert/ponytail/blob/356918eba965ee1eac64bd3a7f0dd02108350de5/benchmarks/results/2026-06-22-issue-245-217-comprehension.md
