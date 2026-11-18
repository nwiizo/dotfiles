# Local Agent Environment

This macOS environment is managed in the dotfiles repository.
Edit managed sources and preserve existing work; the repository overview supplies
the source map and required checks.

## Working Preferences

- Complete requested implementation and its verification. Resolve routine choices
  from repository evidence; ask about missing decisions that change the result.
  Continue independent authorized work and carry prior authorization forward.
- Consult past-session logs and investigation notes only when the current task
  needs them. Treat them as evidence, not standing instructions; check historical
  decisions against the active request and current files before applying them.
- User instructions take precedence over skill guidelines within tool permissions.
  If a skill requires an actual pause, identify the exact file and instruction
  instead of inferring another approval stage.
- Choose skills by the requested deliverable and unresolved problem; honor
  explicitly requested skills. Use writing and polishing workflows for requested
  prose work. For the wording of ordinary technical replies and code/config
  change reports, use the communication guidance below. Read task-relevant
  references and complete the selected skill's applicable required checks.
- Use `nwiizo-coding-style` for implementation and simplification; it routes Rust
  structural work through similarity-rs and cargo-coupling.
- Use subagents only when the user or applicable instructions explicitly request
  delegation. Pass scope, ownership, operations, dependencies, and verification;
  inspect returned artifacts and reconcile the complete result.
- Complete required checks for the changed behavior. Use native validation for
  configuration and isolate automated config/login tests from user credentials.
  Reuse passing checks while their inputs remain unchanged.

## Local Tools

Use Herdr by default for persistent terminal workspaces and authorized agent
coordination. Read the `herdr` skill for setup and control; control existing panes
only from inside their Herdr session. The delegation rule above still applies.
Ghostty opens Fish; launch Herdr when needed rather than attaching at shell startup.
Use either the Herdr CLI or Neovim's Signalbox; existing Codex/Claude entrypoints
remain available. Choose the interface that fits the current work.

Prefix shell commands with `rtk`; use `rtk proxy` for unwrapped commands.
Use Git, preserve user changes, and inspect status and diff.
Commit or push only when requested; verify the branch and remote before publication.
Use conventional commits; omit Co-Authored-By for crown-org and estie repositories.
Keep destructive and permission-bypass shortcuts explicitly named except documented
user-approved exceptions. Preserve the recorded c/cx shell expansions.

Use existing CLIs for inspection and editing. Do not write disposable scripts in
Python or another language. Recurring custom processing belongs in a maintained
Rust CLI with a defined job. Keep credentials, logs, and runtime state outside Git.

## Communication

通常の説明と進捗報告は自然な日本語で書く。依頼で言語・形式・読者が指定されたらそれに合わせる。
ソースコード、API、バージョン、確認など、読者がその場面で使う語を選ぶ。
利用者の用語指定は対象に合わせて使う（例：方針・取り決め・動作、本番相当のデータ・検証環境）。
コード、コマンド、識別子、引用は元の表記を保つ。

質問には答えを、変更の報告には変わった動作と検証結果を先に書く。
調査では観察した事実から何が言えるかを示し、複数の説明が残るなら、どの証拠で区別できるかを書く。
設計の比較では選択を左右する条件をそろえ、推奨を求められたらその条件に照らして理由を述べる。
解説では仕組みを追える具体例を選ぶ。進捗は簡潔に伝え、残る制約は結果の利用に関わるものを示す。

For GitHub comments, read the issue and latest replies, explain observed behavior
before a recommendation, and ask only for an unresolved decision.
Keep one decision per question and edit an unanswered comment rather than stacking
clarifications.

@RTK.md
