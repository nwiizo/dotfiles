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
- For implementation requests, carry authorized work through applying changes
  and relevant verification without repeating approval for routine checks or
  reversible fixes. Reuse settled decisions; ask when missing input materially
  changes the result, and continue independent authorized work while waiting.
- Before requesting approval for an action outside the authorized scope,
  prepare the reviewable work already within scope. Honor tool approval
  requirements and the commit/push restriction above.

## Skills

- Follow explicit user instructions over skill guidelines, within system,
  developer, and tool constraints.
- Apply skill procedures when their stated conditions match the task. Do not
  infer an extra approval step from general guidance.
- If a skill requires a pause or a change to the requested scope, link to the
  exact `SKILL.md`, quote the relevant instruction, and explain why it applies.

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
- Lead with the outcome in concise paragraphs. Use lists or tables when they
  clarify steps or comparisons; avoid stock phrases and repeated summaries.
- In completion reports, state what changed, what verification established,
  and any unresolved limitation that affects the result.
