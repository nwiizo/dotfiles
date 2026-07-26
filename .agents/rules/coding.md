# Coding Standards

## Commit: `<type>(<scope>): <subject>`

Types: `feat` `fix` `docs` `style` `refactor` `test` `chore`

## Rules
- Prefer editing existing files over creating new ones
- Keep documentation minimal and accurate
- `crown-org` 配下、またはリポジトリ名に `estie` を含む場合は `Co-Authored-By` をコミットメッセージに入れない

## Think Before Coding（実装前の確認）
- 結果やスコープを変える仮定だけを明示する。リポジトリやツールで分かる事実は先に調べる
- 情報が十分なら、妥当な解釈を示して進む。既に決まった事実を再検討しない
- ユーザーだけが答えられる入力、実質的なスコープ変更、破壊的な操作でのみ止まる
- より単純な方法で要求を満たせるなら、選択肢を網羅せず推奨する

## Simplicity First（過剰実装の禁止）
- 依頼以外の機能・抽象化・「柔軟性」を足さない
- 1 回しか使わないコードに interface/factory/builder を作らない
- 発生しえないシナリオへの error handling を書かない
- 200 行書いた後で 50 行で済むと気づいたら書き直す
- セルフテスト: シニアエンジニアが見て「過剰」と言わないか

## Surgical Changes（コード版・外科的編集）
- 隣接コード・コメント・フォーマットを「ついで」に直さない
- 壊れていないものをリファクタしない。既存スタイルに合わせる
- 自分の変更で orphan になった import/変数のみ削除する
- 既存の dead code は依頼されない限り消さず、報告に留める
- 判定基準: 変更された全行がユーザーの依頼に直接トレースできるか
- 文書編集の同原則は [content-editing.md](content-editing.md) を参照

## Goal-Driven Execution（成功基準を先に決める）
- 命令形を宣言形ゴールに変換する
  - 「validation を追加」→「不正入力のテストを書き、通るまで実装」
  - 「バグを直す」→「再現テストを書き、緑にする」
  - 「リファクタ」→「前後でテストが通ることを保証」
- 依存関係のある多段タスクだけ、`手順 → verify: チェック` の形で計画を述べる
- 詳細は skill: `home-karpathy-guidelines`

## Version Control Discipline
- 最初にリポジトリのVCSを確認し、jjでは `jj status` / `jj diff`、Gitでは `git status` / `git diff` を使う
- コミット前に、確定対象の正確なdiffと現在のbookmarkまたはbranchを確認する
- 他プロジェクトのファイルを含めてコミットしない
- プロジェクトリポジトリ内で作業中に `~/.claude/` のグローバル設定を変更しない
- push前にremote差分と対象bookmarkまたはbranchを確認し、ユーザーの依頼と保護ルールに従う
- バックアップbranch、bookmark、stashを依頼なく作らない。復旧点が本当に必要な操作では、対象と戻し方を確認してから作る

## Evidence and Reporting
- 進捗と完了の主張は、この実行で得たコマンド出力・差分・成果物に対応づける
- 成功、失敗、未実行を分ける。エージェントの自己申告だけで完了扱いしない
- 最終報告は結果を先に書き、次の判断を変えない作業実況や検討しなかった選択肢を省く
