@AGENTS.md

## Claude Code

- Claude Code project entrypoints live under `.claude/` and symlink to the
  reusable sources in `.agents/`.
- Keep this file small. Put durable repo rules in `AGENTS.md`, path-scoped
  Claude rules in `.agents/rules/`, repeatable workflows in `.agents/skills/`,
  and specialized reviewer/delegation personas in `.agents/agents/`.
- Re-run `./scripts/link.sh` after changing user-level Claude assets.
