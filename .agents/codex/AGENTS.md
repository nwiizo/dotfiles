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
  Use a skill for its stated job. If it requires an actual pause, identify the
  exact file and instruction instead of inferring another approval stage.
- Use `nwiizo-coding-style` for implementation and simplification; it routes Rust
  structural work through similarity-rs and cargo-coupling.
- Use subagents only when the user or applicable instructions explicitly request
  delegation. Pass scope, ownership, operations, dependencies, and verification;
  inspect returned artifacts and reconcile the complete result.
- Complete required checks for the changed behavior. Use native validation for
  configuration and isolate automated config/login tests from user credentials.
  Reuse passing checks while their inputs remain unchanged.

## Local Tools

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

Lead with the outcome or next executable action. Use concise, natural Japanese
and concrete behavior. Prefer 方針・取り決め・動作 for software, and
本番相当のデータ・検証環境 when describing data or environments.
Use the user's established vocabulary restrictions.
Explain a change, its current verification, and any material remaining limit.
Use lists for actual steps or comparisons; avoid repeated recaps and closing filler.

For GitHub comments, read the issue and latest replies, explain observed behavior
before a recommendation, and ask only for an unresolved decision.
Keep one decision per question and edit an unanswered comment rather than stacking
clarifications.
