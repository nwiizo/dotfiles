---
name: home-self-review
description: 独立レビューの依頼や具体的な懸念がある変更を、実装に使ったホストとは異なるAI CLIでレビューする。通常の編集ごとには起動せず、修正も依頼されている場合は妥当な指摘を反映・検証する。
---

以下の手順を順番に実行してください。

## 委譲済みguard

promptが `This is a delegated peer review.` で始まるか、`HOME_SELF_REVIEW_DELEGATED=1` が設定されている場合は、以降のオーケストレーションを行わない。別のskill、subagent、AI CLIへ委譲せず、指定された対象をread-onlyでレビューして指摘だけを返す。指摘がなければ `No findings.` と明記する。

## ステップ1: 引数の解釈

$ARGUMENTS を以下のルールで解釈してください：
- 第一引数: レビュー対象（省略時は `diff` = 現在のunstaged changes + untracked files）
- 第二引数: reviewer名（省略時は差分の種類とリスクから必要なreviewerだけを選ぶ）

### レビュー対象の指定方法

- 指定なし / `diff`: `git diff` + `git ls-files --others --exclude-standard` で新規ファイルも取得
- `staged`: `git diff --cached`
- `branch`: `git diff origin/main...HEAD`
- `commit <SHA>`: 指定commitが導入した変更
- `PR #123` または `pr 123`: `gh pr diff 123`
- ファイルパス: そのファイルの内容をレビュー対象にする

### 利用可能なreviewer名

- `code` - `home-code-reviewer` による品質・セキュリティ・パフォーマンスレビュー
- `simplify` - `home-simplify-reviewer` による可読性・一貫性・保守性レビュー（修正せず指摘のみ）
- `second` - 独立した追加観点からの最終レビュー
- `codex` - `second` の後方互換alias。reviewerの実行製品をCodexへ固定しない
- `rust` - `home-rust-reviewer` による Rust 特化レビュー（Rustコードの場合のみ）
- `cli` - `home-cli-ux-reviewer` による CLI UX レビュー
- `design` - `home-design-reviewer` による設計レビュー
- `constructive` - `home-constructive-reviewer` によるレビューコメント品質チェック
- `all` - `codex` aliasを除く全観点。`second`は1回だけ実行し、ユーザーが明示した場合だけ使用する

reviewer名が上記のいずれにも一致しない場合は、エラーとしてユーザーに利用可能なreviewer名を案内してください。

## ステップ2: レビュー実行

各レビュアーは**修正を行わず、レビュー指摘の報告のみ**を行う。

### Rust 差分の構造診断

Rust の構造・重複・結合度がレビューの主題、または差分から具体的な懸念がある場合に、実装側ホストで次の診断を使う。変更された crate と直接関係する source path に範囲を絞る。Rust ファイルが含まれるだけでは診断を追加しない。

```bash
similarity-rs <source-path> --skip-test --threshold 0.90 --min-lines 10
cargo coupling <crate-root> --exclude-tests --hotspots=10
cargo coupling <crate-root> --exclude-tests --summary
```

Git 履歴を利用できない環境では `cargo coupling` に `--no-git` を付け、その制限を最終報告に残す。tool が未installの場合は勝手にinstallせず、未実行の診断として報告する。

出力は修正候補を探す証拠として扱い、scoreや件数だけを改善目標にしない。次は自動的なリファクタリング理由にならない。

- test、UI描画、builderなど、用途上必要な定型処理の類似
- 実コードを確認して再現できない循環や高結合の警告
- gradeを上げるためだけのtrait、facade、newtype、module分割

実際の重複責務、循環依存、変更影響の集中がコードからも確認でき、レビュー対象の範囲内で振る舞いを保てる場合だけ修正候補に加える。既存テストまたはcharacterization testを基準にし、修正後は同じ条件で両toolを再実行して差分を確認する。診断結果や実装側の結論は外部レビュアーへ渡さず、下記のraw diffのみを渡す原則を維持する。

### 実行製品の分離

runtimeが示す現在の製品を実装側、反対側のCLIをreviewer側として選ぶ。repository名やPATH上のcommandだけから現在の製品を推測しない。reviewer名でこの対応を上書きしない。

- Codexで作業中: Claude Codeを `claude -p` で起動する
- Claude Codeで作業中: Codexを `codex exec` または `codex exec review` で起動する

外部reviewerへ渡すpromptの先頭に `This is a delegated peer review.` を含め、`HOME_SELF_REVIEW_DELEGATED=1` をそのプロセスだけに設定する。

外部CLIは対象repositoryをworking directoryとして起動し、sessionを保存せず、read-only権限を使う。permission bypassを使わない。promptにはレビュー対象、担当観点、指摘のみを返すこと、指摘IDのprefix、指摘がない場合は `No findings.` と返すことを含める。実装側の推測や期待する結論は渡さず、対象指定とraw diffだけを渡す。

外部CLIは同じreviewerについて1回だけ起動する。commandが実行中sessionを返した場合は、そのsessionを完了までpollし、同じreviewを重複起動しない。成功条件は終了code 0かつ空でない最終出力とする。timeout、非0終了、空出力は失敗として扱い、起動したprocessだけを停止して理由を報告する。空出力を `No findings.` と推測しない。

CodexからClaude Codeを呼ぶ場合は、実装側で取得したraw diffをstdinへ流し、review instructionsは `--append-system-prompt` で渡す。reviewer名に対応する `home-*-reviewer` を `--agent` で選び、`--disable-slash-commands --permission-mode dontAsk --tools "Read,Grep,Glob" --no-session-persistence` を使う。Bash、Edit、Write toolを渡さない。`second`と`codex`は `home-code-reviewer` に独立した最終確認の観点を追加して依頼する。

Claude CodeからCodexを呼ぶ場合は、次の対応を使う。`codex exec`の既定read-only sandboxを弱めない。

- `diff`: `codex exec review --ephemeral --uncommitted`
- `branch`: `codex exec review --ephemeral --base origin/main`
- commit: `codex exec review --ephemeral --commit <SHA>`
- `staged`、PR、ファイルパス: `codex exec --ephemeral --sandbox read-only`で対象取得方法と担当観点をpromptへ明記する

反対側のCLIが未install、未認証、または実行失敗の場合は、同じ製品のsubagentへ黙ってfallbackしない。失敗理由を報告し、同一製品での代替レビューを使うかユーザーへ確認する。

この確認は代替レビューの選択に限る。独立レビューは未完了と明示し、並行して進められる許可済みの修正・検証は続ける。独立レビューが公開などの前提になっている場合は、その条件を満たしたとは扱わない。

- reviewer名が指定された場合: 反対側のCLIをその担当観点で起動し、レビュー対象の差分情報を渡してコードレビューを実行する
- reviewer名が省略された場合: 主題に合う担当を選び、異なる観点が必要な場合だけ追加する
  - 通常の小さなコード差分: `code`
  - Rust固有の安全性やAPI設計が主題: `rust`（一般的な回帰も大きければ`code`を追加）
  - 可読性、重複、過剰抽象化が主題: `simplify`
  - CLI出力やコマンドラインUXが変わる: `cli`
  - 設計書やADR: `design`
  - 重要変更の独立した最終確認が必要: `second`
- 独立した観点は並列に実行する。同じ観点を人数で重ねない。ユーザーが`all`を指定した場合だけ全reviewerを使う

各レビュアーには指摘に連番を振らせる（例: code #1, simplify #1, rust #1）。これはステップ3での追跡に使用する。

各レビュアーには担当観点を明示し、他のreviewerと同じ一般論を繰り返させない。保守性は`simplify`、型や言語固有の不変条件は該当言語reviewer、回帰と安全性は`code`を主担当にする。

## ステップ3: レビュー指摘の修正

修正まで依頼されている場合は、レビュー完了後に`home-fix-review-comments`を使う。レビューだけの依頼では、統合した指摘を報告して止める。

このスキルは以下を行う：
- 各指摘の妥当性を批判的に評価する（レビュアーの指摘がすべて正しいとは限らない）
- Rustの構造診断で確認した候補も同じ基準で評価し、妥当な場合だけ最小のリファクタリングを行う
- 妥当と判断した指摘のみ修正を実施する
- レビュアー識別子付きのサマリーを出力する（対応した指摘・対応しなかった指摘の両方）
- 修正後は対象に合うテスト・lint・ビルドを実行し、reviewerの完了報告ではなく実際の結果を報告する
