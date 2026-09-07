# Coding Preferences

## Implementation

- Prefer the first sufficient option: no new code, existing code, standard library, native feature, installed dependency, then a small implementation. Preserve necessary validation, safety, accessibility, and verification.
- Use `home-karpathy-guidelines` when material uncertainty or an explicit minimal/YAGNI request needs a preflight. Do not repeat its checklist in ordinary tasks.
- For implementation requests, carry authorized work through applying changes and relevant verification using repository evidence and reasonable defaults. Reuse settled decisions; ask about missing input that materially affects the result, and continue independent authorized work while waiting.
- Before seeking approval for an action outside the authorized scope, prepare the reviewable work already within scope. Preserve tool approval requirements and the commit/push restriction below.
- For persisted data or public interfaces, use `home-data-shape-contract` to assess compatibility. Already specified or agreed shapes do not need another approval.
- Fix the cause across the affected flow. Keep unrelated edits out of the diff.

## Skills

- Follow explicit user instructions over skill guidelines, within system, developer, and tool constraints.
- Apply skill procedures when their stated conditions match the task. Do not infer an extra approval step from general guidance.
- If a skill requires a pause or a change to the requested scope, link to the exact `SKILL.md`, quote the relevant instruction, and explain why it applies.

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

Lead with the outcome in concise paragraphs. Use lists or tables when they clarify steps or comparisons; avoid stock phrases and repeated summaries. Use concrete, idiomatic Japanese when writing in Japanese.

State what changed, what verification established, and any unresolved limitation that affects the result. Tie claims to current command results or inspected artifacts; a reviewer's report alone is not proof.
