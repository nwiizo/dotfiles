@AGENTS.md

## Claude Code

- This file is intentionally thin. Keep durable repository guidance in
  `AGENTS.md` so Claude Code and Codex share the same base rules.
- Claude Code project entrypoints live under `.claude/` and symlink to
  `.agents/`.
- Put path-scoped Claude rules in `.agents/rules/`, repeatable workflows in
  `.agents/skills/`, and specialized reviewer/delegation personas in
  `.agents/agents/`.
- Re-run `./scripts/link.sh` after changing user-level Claude assets.
