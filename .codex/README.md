# Codex Entry Points

Codex reads repository skills from `.agents/skills` and project custom agents
from `.codex/agents`.

This repository keeps reusable Codex agent definitions in `.agents/codex/` and
exposes them here as symlinks:

| Path | Source |
|---|---|
| `agents/` | `../.agents/codex/agents/` |

Use `.agents/codex/agents/` for edits. `scripts/link.sh` also links these
agents into `~/.codex/agents` for user-level reuse.
