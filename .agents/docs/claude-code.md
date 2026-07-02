# Claude Code Notes

Use this file as routing guidance for the dotfiles-managed Claude Code assets.

## Placement

| Need | Put it in |
|---|---|
| Repo-wide instructions | `CLAUDE.md`, importing `AGENTS.md` |
| User-wide instructions | `.agents/CLAUDE.md` linked to `~/.claude/CLAUDE.md` |
| Path-scoped or topic rules | `.agents/rules/` exposed as `.claude/rules/` |
| Repeatable workflows | `.agents/skills/<name>/SKILL.md` exposed as `.claude/skills/` |
| Specialized delegation persona | `.agents/agents/<name>.md` exposed as `.claude/agents/` |
| Machine-local permissions, credentials, or experiments | `~/.claude/settings.local.json` or other untracked local state |

## Rules

- Keep `CLAUDE.md` concise. Move multi-step procedures to skills and
  conditional instructions to rules.
- Use reviewer and planner personas as subagents, not skills. Skills can
  orchestrate review flows or apply accepted review comments.
- Prefer read-only tool lists for reviewer subagents.
- Do not track sessions, auto memory, auth caches, daemon state, logs, plugin
  caches, or settings with machine-specific values.
- Use hooks only for lifecycle automation or enforcement. Behavioral guidance
  belongs in `CLAUDE.md`, rules, skills, or agents.

## Sources

- Claude Code memory and CLAUDE.md: https://code.claude.com/docs/en/memory
- Claude Code subagents: https://code.claude.com/docs/en/sub-agents
- Claude Code skills: https://code.claude.com/docs/en/skills
- Claude Code settings: https://code.claude.com/docs/en/settings
- Claude Code hooks: https://code.claude.com/docs/en/hooks
