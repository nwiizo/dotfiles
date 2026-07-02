# Claude Code Entry Points

Claude Code reads project subagents, skills, and rules from `.claude/`.
This repository keeps the source files in `.agents/` and exposes them here as
symlinks:

| Path | Source |
|---|---|
| `agents/` | `../.agents/agents/` |
| `rules/` | `../.agents/rules/` |
| `skills/` | `../.agents/skills/` |

Use `.agents/` for edits. These symlinks make the same assets available as
project-scoped Claude Code configuration while `scripts/link.sh` also links
them into `~/.claude`.
