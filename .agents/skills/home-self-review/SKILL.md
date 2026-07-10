---
name: home-self-review
description: 手元のコード変更を、リスクに合う最小限の独立レビュアーで確認し、妥当な指摘だけを修正・検証する。diff/staged/branch/PRを対象に使用する。
argument-hint: "[レビュー対象] [reviewer名]"
---

以下の手順を順番に実行してください。

## ステップ1: 引数の解釈

$ARGUMENTS を以下のルールで解釈してください：
- 第一引数: レビュー対象（省略時は `diff` = 現在のunstaged changes + untracked files）
- 第二引数: reviewer名（省略時は差分の種類とリスクから必要なreviewerだけを選ぶ）

### レビュー対象の指定方法

- 指定なし / `diff`: `git diff` + `git ls-files --others --exclude-standard` で新規ファイルも取得
- `staged`: `git diff --cached`
- `branch`: `git diff origin/main...HEAD`
- `PR #123` または `pr 123`: `gh pr diff 123`
- ファイルパス: そのファイルの内容をレビュー対象にする

### 利用可能なreviewer名

- `code` - `home-code-reviewer` による品質・セキュリティ・パフォーマンスレビュー
- `simplify` - `home-simplify-reviewer` による可読性・一貫性・保守性レビュー（修正せず指摘のみ）
- `codex` - `home-codex-reviewer` による追加観点からのレビュー
- `rust` - `home-rust-reviewer` による Rust 特化レビュー（Rustコードの場合のみ）
- `cli` - `home-cli-ux-reviewer` による CLI UX レビュー
- `design` - `home-design-reviewer` による設計レビュー
- `constructive` - `home-constructive-reviewer` によるレビューコメント品質チェック

reviewer名が上記のいずれにも一致しない場合は、エラーとしてユーザーに利用可能なreviewer名を案内してください。

## ステップ2: レビュー実行

各レビュアーは**修正を行わず、レビュー指摘の報告のみ**を行う。

- reviewer名が指定された場合: そのreviewerのエージェントを起動し、レビュー対象の差分情報を渡してコードレビューを実行する
- reviewer名が省略された場合: 差分の言語、成果物、失敗時の影響から1〜3名を選ぶ
  - 通常の小さなコード差分: `code`
  - Rust固有の安全性やAPI設計が主題: `rust`（一般的な回帰も大きければ`code`を追加）
  - 可読性、重複、過剰抽象化が主題: `simplify`
  - CLI出力やコマンドラインUXが変わる: `cli`
  - 設計書やADR: `design`
  - 重要変更の独立した最終確認が必要: `codex`
- 独立した観点は並列に実行する。同じ観点を人数で重ねない。ユーザーが`all`を指定した場合だけ全reviewerを使う

各レビュアーには指摘に連番を振らせる（例: code #1, simplify #1, rust #1）。これはステップ3での追跡に使用する。

各レビュアーには担当観点を明示し、他のreviewerと同じ一般論を繰り返させない。保守性は`simplify`、型や言語固有の不変条件は該当言語reviewer、回帰と安全性は`code`を主担当にする。

## ステップ3: レビュー指摘の修正

修正まで依頼されている場合は、レビュー完了後に`home-fix-review-comments`を使う。レビューだけの依頼では、統合した指摘を報告して止める。

このスキルは以下を行う：
- 各指摘の妥当性を批判的に評価する（レビュアーの指摘がすべて正しいとは限らない）
- 妥当と判断した指摘のみ修正を実施する
- レビュアー識別子付きのサマリーを出力する（対応した指摘・対応しなかった指摘の両方）
- 修正後は対象に合うテスト・lint・ビルドを実行し、reviewerの完了報告ではなく実際の結果を報告する
