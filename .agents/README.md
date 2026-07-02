# Agent Config

This directory contains reusable agent configuration that is safe to keep with
dotfiles and link into local agent homes.

## Managed

| Path | Linked to | Purpose |
|---|---|---|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | Claude Code entry point |
| `RTK.md` | `~/.claude/RTK.md` | RTK command guidance |
| `claudeignore` | `~/.claude/.claudeignore` | Global ignore patterns |
| `agents/` | `~/.claude/agents`, `~/.agents/agents` | Reusable subagent prompts |
| `rules/` | `~/.claude/rules`, `~/.agents/rules` | Reusable coding and authoring rules |
| `docs/` | `~/.claude/docs`, `~/.agents/docs` | On-demand technical notes |
| `skills/` | `~/.claude/skills/*`, `~/.agents/skills/*` | Reusable skills |
| `codex/agents/` | `~/.codex/agents/*.toml` | Reusable Codex subagents |

`scripts/link.sh` links skill directories one by one. This keeps room for
external skills such as `nippo`, which belongs to its own repository.

Review judgment belongs in `agents/`. Skills may orchestrate review flows or
apply accepted review comments, but reviewer personas and checklists should be
implemented as subagents.

## Excluded

The following are local state or machine-specific policy and are not tracked here:

- conversation history, project sessions, file history, and plans
- settings files with machine-specific paths or permissions
- daemon files, control keys, auth caches, security state, and logs
- plugin caches, downloaded artifacts, and other runtime data
- backups created by agent tools
- local Codex approval rules with project-specific paths
