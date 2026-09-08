# Dotfiles Repository

Manage this macOS environment through repository sources and direct symlinks.
Homebrew owns binaries in `Brewfile`; `scripts/` applies and validates config.
Read the affected area's README for its current behavior and maintenance notes.

## Where to Edit

Edit repository sources, not linked targets under `~/.config` or agent homes.

| Area | Source |
|---|---|
| Packages | `Brewfile` |
| Fish | `fish/config.fish`, autoloaded `fish/functions/<name>.fish`; vendor overrides in `fish/conf.d/` use the upstream basename |
| Neovim | `nvim/lua/config/` and feature-grouped `nvim/lua/plugins/` |
| Terminals and CLI apps | `ghostty/`, `gpane/`, `git/`, `gh/`, `bat/`, `atuin/`, `tealdeer/` |
| Agent preferences and workflows | `.agents/`; project `.claude/` entrypoints and `.codex/agents` link there |
| Skills and personas | `.agents/skills/<name>/SKILL.md`; same-named Claude Markdown and Codex TOML personas in `.agents/agents/` and `.agents/codex/agents/` |

Keep `nvim/lazy-lock.json` tracked: `:Lazy update` advances revisions and
`:Lazy restore` reproduces them. Review lock changes with their related config.
`archive/` is reference-only; edit it only when explicitly requested.

## Apply Changes

- Use `rtk proxy ./scripts/bootstrap.sh` for requested environment setup.
  It installs packages, links configs, and installs Fish plugins.
- Run `rtk proxy ./scripts/link.sh` when adding, removing, or changing an
  installation path. Existing linked-file edits need no relinking; reload
  the owning app as needed and verify the effective setting. Report changes
  that only take effect in new sessions, tabs, or windows.
- `rtk proxy fish scripts/install-fish-plugins.fish` applies `fish/fish_plugins`.

## Verify the Result

Select checks for the affected area and complete its required validation:

| Changed area | Checks |
|---|---|
| Fish | Run `rtk proxy fish -n` on each affected `.fish` file. |
| Neovim | `rtk proxy stylua --check nvim/lua`; `rtk proxy jq empty nvim/lazy-lock.json`; `rtk proxy nvim --headless '+lua print("nvim-config-ok")' +qa` |
| Neovim external-change merging | Also run `rtk proxy nvim --headless -u NONE -l nvim/tests/external_changes.lua` |
| Homebrew packages | `rtk proxy brew bundle check --file Brewfile` |
| Agent instructions, skills, or personas | `rtk proxy ./scripts/audit-agent-config.sh` |
| Other app config | Use the app's native validation and the relevant checks in its README. |

The agent audit checks links, metadata, persona pairs, invocation and read-only
policy parity, stale references, and generated state. It needs Ruby/Psych, yq,
and jq, and runs git-secrets when installed.

For config edits, use native validation and exercise changed lazy-loaded
integrations; startup alone does not establish their behavior. Repeat or broaden
passing checks only for new changes, failures, or unresolved concerns.

## Repository Preferences

- Use Git only; do not install, invoke, or recommend Jujutsu. Inspect
  `git status` and `git diff`, preserve existing user changes, and stage only
  intended paths. Commit or push only when requested; use concise conventional commits.
- Do not track sessions, logs, caches, credentials, local settings, or generated
  state. Run `git secrets --scan` before publishing agent or history-derived assets.
- Short/default aliases stay guarded unless the source records a user-approved
  exception. The `c` and `cx` abbreviations in `fish/config.fish` must retain
  their permission-bypass expansions. Other bypasses and destructive operations
  need explicit names and verified targets.
- Do not replace standard commands with Fish functions that implement a different
  CLI. Prefer maintained Rust tools for interactive ergonomics and expose
  incompatible replacements as visible abbreviations.
