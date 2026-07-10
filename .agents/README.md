# Agent Config

This directory is the source of truth for reusable agent configuration that is
safe to keep with dotfiles. Project entrypoints under `.claude/` and `.codex/`
symlink back here, and `scripts/link.sh` also links selected assets into user
agent homes.

## Managed

| Path | Linked to | Purpose |
|---|---|---|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | Claude Code entry point |
| `RTK.md` | `~/.claude/RTK.md` | RTK command guidance |
| `claudeignore` | `~/.claude/.claudeignore` | Global ignore patterns |
| `agents/` | `~/.claude/agents` | Reusable Claude Code subagent prompts |
| `rules/` | `~/.claude/rules` | Reusable Claude Code rules |
| `docs/` | `~/.claude/docs` | On-demand Claude Code technical notes |
| `skills/` | `~/.claude/skills/*`, `~/.agents/skills/*` | Reusable skills |
| `codex/agents/` | `~/.codex/agents/*.toml` | Reusable Codex subagents |
| `.claude/` symlinks | project `.claude/*` | Claude Code project entrypoints |
| `.codex/agents` symlink | project `.codex/agents` | Codex project custom-agent entrypoint |

`scripts/link.sh` links skill directories one by one. This keeps room for
external skills such as `nippo`, which belongs to its own repository.

Only portable Agent Skills are published under `~/.agents`. Keep
product-specific assets under `~/.claude` or `~/.codex`. Shared skills may use
client extensions when required: Claude Code fields stay in `SKILL.md`, while
Codex UI and invocation policy belong in `agents/openai.yaml`.

Review judgment belongs in subagents. Skills may orchestrate review flows or
apply accepted review comments, but reviewer personas and checklists should be
implemented as Claude Code agents and Codex custom agents.

Use `scripts/audit-agent-config.sh` after changing this tree. Use
`scripts/summarize-ai-history.py` only on temporary collector output under
`/tmp`; never commit raw AI conversation logs.

## Excluded

The following are local state or machine-specific policy and are not tracked here:

- conversation history, project sessions, file history, and plans
- settings files with machine-specific paths or permissions
- daemon files, control keys, auth caches, security state, and logs
- plugin caches, downloaded artifacts, and other runtime data
- backups created by agent tools
- local Codex approval rules with project-specific paths
