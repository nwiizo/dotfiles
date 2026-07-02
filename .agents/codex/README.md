# Codex Agent Config

This directory contains reusable Codex agent definitions.

## Managed

| Path | Linked to | Purpose |
|---|---|---|
| `agents/*.toml` | `~/.codex/agents/*.toml` | Reusable Codex subagents |

## Excluded

`~/.codex/rules/default.rules` is intentionally not tracked. It contains
machine-local approval rules and project-specific paths.
