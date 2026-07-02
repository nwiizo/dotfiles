# Coding Standards

## Commit: `<type>(<scope>): <subject>`

Types: `feat` `fix` `docs` `style` `refactor` `test` `chore`

## Rules
- Prefer editing existing files over creating new ones
- Keep documentation minimal and accurate
- `crown-org` 配下、またはリポジトリ名に `estie` を含む場合は `Co-Authored-By` をコミットメッセージに入れない

## Think Before Coding（実装前の確認）
- 仮定は明示し、不確実なら聞く。黙って 1 つの解釈を選ばない
- 複数解釈があれば全部提示し、トレードオフを並べる
- より単純な代替案があれば押し返す
- 不明点は名指しして止まる。曖昧なまま走らない

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
- 多段タスクは `手順 → verify: チェック` の形で計画を述べる
- 詳細は skill: `home-karpathy-guidelines`

## Git Discipline
- コミット前に必ず `git status` と `git diff --staged` を確認する
- 現在のブランチを確認してからコミットする
- 他プロジェクトのファイルを含めてコミットしない
- プロジェクトリポジトリ内で作業中に `~/.claude/` のグローバル設定を変更しない
- 複雑な操作前に `git stash push -m 'checkpoint'` で安全地点を作る
