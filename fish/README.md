# Fish Shell

This directory holds the Fish configuration. `scripts/link.sh`
symlinks `config.fish`, `conf.d/`, and custom functions into
`~/.config/fish/`. `fish_plugins` is the repo-managed desired plugin list;
Fisher writes `~/.config/fish/fish_plugins` when
`scripts/install-fish-plugins.fish` runs.

## Layout

| Path | Role |
|---|---|
| `config.fish` | Main shell init, abbreviations, env vars, and tool integrations |
| `fish_plugins` | Repo-managed Fisher desired plugin list |
| `functions/` | Custom fish functions (prompt, AI helpers, jj wrappers, `update_all`, etc.) |
| `conf.d/` | Early PATH setup, cached mise/direnv hooks, and Fish 4.x compatibility snippets |

## How edits flow

1. Edit `config.fish`, `fish_plugins`, or files under `conf.d/` and `functions/`.
2. Run `../scripts/link.sh` when adding/removing files.
3. Run `fish ../scripts/install-fish-plugins.fish` when changing plugins.
4. New shells pick up changes; reload the shell with `exec fish`.

## Agent-assisted workflow

The short aliases are safe by default. `c` starts Claude Code and `cx`
starts Codex with their normal permission checks. The bypass modes remain
available as the deliberately explicit `cunsafe` and `cxunsafe` aliases.

| Command | Purpose |
|---|---|
| `ast` | `ast-grep` structural search and rewrite |
| `awatch <command...>` | Re-run verification whenever an agent changes files |
| `wx` | Direct `watchexec` access |
| `private` | Start `fish --private` without reading or writing history |

For example, keep a Rust test loop next to Claude Code or Codex:

```fish
awatch cargo test --all
```

Watchexec uses native filesystem events, respects project ignore files, and
restarts an in-flight verification when a newer edit arrives.

## Startup behavior

Interactive shells use full `mise activate` behavior, including directory
hooks and environment variables. Non-interactive agent commands add mise's
shim directory directly, avoiding a startup subprocess while keeping project
tools available.

Repo-managed `conf.d` entries take precedence over Homebrew's generated mise
and direnv hooks. Their output, along with carapace, Atuin, and zoxide
integration code, is cached under
`${XDG_CACHE_HOME:-$HOME/.cache}/fish/generated/`. A changed executable path or
modification time, or a changed init command line, regenerates its cache
automatically. The cache is local runtime state and is intentionally not
tracked.

macOS supplies `SSH_AUTH_SOCK` through the login session, so Fish inherits the
native agent instead of running `ssh-add` during every shell startup.

Long-command notifications are handled by Ghostty's native configuration, so
the Fisher `done` plugin is intentionally not installed.

## What's not here

- `fish_variables` — local Fish universal variables/runtime state.
- `~/.config/fish/fish_plugins` — Fisher's normalized installed plugin file.
- Tool caches and histories (`atuin`, `fzf`, shell history).

## Editing Rules

- Do not edit `~/.config/fish/config.fish` directly.
- Define `fish_prompt` and `fish_right_prompt` only under `fish/functions/`.
