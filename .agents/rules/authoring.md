---
paths:
  - "**/AGENTS.md"
  - "**/CLAUDE.md"
  - "**/SKILL.md"
  - "**/.agents/**/*"
  - "**/.claude/**/*"
  - "**/.codex/**/*"
  - "**/.claude-plugin/**/*"
  - "**/.codex-plugin/**/*"
---

# Agent Instruction Authoring

- Write what changes a capable model's decisions: user preferences, environment facts, domain-specific pitfalls, and real safety boundaries. Remove generic tutorials, repeated warnings, and workarounds whose purpose no longer applies.
- Keep shared defaults in entrypoints, path-specific preferences in rules, and task-specific judgment or procedures in skills. Delete redundant content instead of moving it into a new file.
- Describe the intended outcome and constraints. Fix step order, approval gates, output formats, or numeric limits only when the task or user requires them.
- Preserve user authorization. Do not turn a past incident or one project's convention into a universal restriction.
- Reusable personal workflows and personas use the `home-` prefix; preserve established names and external skills.
- Keep shared Claude/Codex personas paired by name. Read-only roles use Claude `permissionMode: plan` and Codex `sandbox_mode = "read-only"`; diagnostic Bash access is not permission to mutate.
- Skills require a matching `name` and a concise `description` that distinguishes nearby tasks. Preserve client extensions and existing invocation policy.
- Manual-only skills need both Claude `disable-model-invocation: true` and Codex `policy.allow_implicit_invocation: false`. Do not infer manual-only invocation merely from possible side effects.
- Keep skill bodies as short as the task permits. Link substantial conditional references with a reading condition; do not duplicate them in the body.
- A Claude `@path` import is not deferred loading. Avoid importing task-specific manuals into startup context.
- Use the existing repository audit for metadata, persona pairs, and links. Do not install a validator or delete supported metadata just to satisfy another client's validator.
- Trace relevant requests after workflow changes. Use `home-empirical-prompt-tuning` when independent behavioral comparison would resolve a meaningful uncertainty; static checks do not establish model performance.
