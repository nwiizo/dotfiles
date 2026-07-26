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

## Choose the smallest instruction surface

| Need | Surface |
|---|---|
| Repository facts, commands, completion criteria | `AGENTS.md`; import it from `CLAUDE.md` |
| Claude-only policy | `.agents/rules/*.md`; add `paths` unless it is truly universal |
| Repeatable workflow or detailed reference | `.agents/skills/<name>/` |
| Deterministic enforcement at a lifecycle event | hook, config, or validation script |
| Shareable bundle of skills, tools, or connectors | plugin |

Keep always-loaded guidance short and concrete. Add durable guidance after
repeated friction, not as speculative policy. Skills should keep portable
`name` and `description` metadata, load detailed references only when needed,
and separate Claude Code invocation controls from Codex
`agents/openai.yaml` policy.

Official references:

- [OpenAI: Build skills](https://learn.chatgpt.com/docs/build-skills)
- [OpenAI: Codex best practices](https://learn.chatgpt.com/guides/best-practices)
- [Anthropic: Claude Code extensions](https://code.claude.com/docs/en/features-overview)
- [Anthropic: Claude Code skills](https://code.claude.com/docs/en/skills)
- [Anthropic: CLAUDE.md and path-scoped rules](https://code.claude.com/docs/en/memory)

Use `scripts/audit-agent-config.sh` after changing this tree. It checks shared
skill frontmatter, requires directory/name identity and a non-empty
description, and enforces manual-only invocation policy in both Claude Code
and Codex. Client-specific interface text and forward-test quality remain
manual review items. The YAML checks require Ruby with its standard Psych
library. Use `scripts/summarize-ai-history.py` only on temporary collector
output under `/tmp`; never commit raw AI conversation logs.

## Excluded

The following are local state or machine-specific policy and are not tracked here:

- conversation history, project sessions, file history, and plans
- settings files with machine-specific paths or permissions
- daemon files, control keys, auth caches, security state, and logs
- plugin caches, downloaded artifacts, and other runtime data
- backups created by agent tools
- local Codex approval rules with project-specific paths
