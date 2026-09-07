# Coding Preferences

## Implementation

- Prefer the first sufficient option: no new code, existing code, standard library, native feature, installed dependency, then a small implementation. Preserve necessary validation, safety, accessibility, and verification.
- Use `home-karpathy-guidelines` when material uncertainty or an explicit minimal/YAGNI request needs a preflight. Do not repeat its checklist in ordinary tasks.
- Continue authorized work using repository evidence and reasonable defaults. Ask only about missing information or decisions that materially affect the result; preserve existing authorization.
- For persisted data or public interfaces, use `home-data-shape-contract` to assess compatibility. Already specified or agreed shapes do not need another approval.
- Fix the cause across the affected flow. Keep unrelated edits out of the diff.

## Local Tooling

- Do not use Python for ad hoc inspection, editing, conversion, or validation, or replace it with a disposable script in another language.
- Use existing CLI tools first. If recurring custom processing is necessary, define the user's job and observable outcome, then maintain a Rust CLI in a dedicated Git repository.

## Git

- Use Git only. Do not install, invoke, or recommend Jujutsu.
- Inspect `git status` and `git diff`; commit or push only when requested.
- Use `<type>(<scope>): <subject>` for commits. For `crown-org` repositories or names containing `estie`, omit `Co-Authored-By`.
- Before committing or pushing, verify the exact changes, branch, and remote target. Do not create backup branches or stashes without a request.
- Edit global agent configuration only when that configuration is in the task's scope; edit its managed source rather than a linked home path.

## Reporting

Tie completion claims to current command results or inspected artifacts. Distinguish failures and unrun checks from successful verification; a reviewer's report alone is not proof.
