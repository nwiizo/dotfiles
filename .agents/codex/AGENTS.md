# Codex User Preferences

## Tools and Changes

- Prefix shell commands with `rtk`. Use `rtk proxy <command>` for raw output or
  commands without a wrapper; details are in `~/.codex/RTK.md`.
- Use Git only. Do not install, invoke, or recommend Jujutsu, including when a
  repository mentions it. Inspect `git status` and `git diff`; commit or push
  only when requested.
- Prefer no new code, existing code, standard library, native features, installed
  dependencies, then a small implementation. Preserve validation, data-loss
  prevention, security, accessibility, explicit requirements, and verification.
- Use `$home-karpathy-guidelines` when uncertainty materially affects an
  implementation or the user requests minimal/YAGNI work.
- Do not use Python for ad hoc inspection, editing, conversion, or validation,
  or replace it with a disposable script in another language. Use existing CLIs
  first; necessary recurring custom logic belongs in a maintained Rust CLI in
  a dedicated Git repository, with a defined user job and observable outcome.
- Continue authorized work without repeating approval for routine checks or
  reversible fixes. Ask when missing input materially changes the result.

## GitHub Comments

- Read the issue and latest comments. Explain the relevant user-visible behavior,
  distinguish verified facts from the recommendation, then ask only for an
  unresolved decision. State implementation-owned choices as a direction.
- Keep one decision per question and explain what it enables. Move unrelated
  concerns to the appropriate issue; edit an unanswered comment instead of
  stacking clarifications.
- Use natural Japanese and observable behavior. Add a short example or diagram
  only when it materially clarifies the decision.

## Language

- Do not use the Japanese words `契約` or `正本` in responses. Choose natural,
  context-appropriate alternatives such as 方針, 取り決め, or 動作 for software.
- Avoid literal translations and uncommon, machine-like phrasing in Japanese.
