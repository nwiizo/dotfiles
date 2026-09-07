# Dotfiles Repository

This repository manages a personal macOS development environment.
Homebrew packages live in `Brewfile`; tool configuration lives in `fish/`,
`nvim/`, `ghostty/`, `warp/`, `git/`, `gh/`, `bat/`, `atuin/`, and
`tealdeer/`. Helper scripts live in `scripts/`.

## Where to Edit

- Edit repository sources, not linked targets under `~/.config` or agent homes.
- Shared agent assets live in `.agents/`. Project `.claude/` entrypoints and
  `.codex/agents` link there. Personal workflows use
  `.agents/skills/<name>/SKILL.md`; personas have same-named Claude Markdown
  and Codex TOML files under `.agents/agents/` and `.agents/codex/agents/`.
- Fish functions use `fish/functions/<name>.fish`; vendor overrides use
  `fish/conf.d/` with the upstream basename.
- Neovim plugin specs use `nvim/lua/plugins/`. Keep `nvim/lazy-lock.json`
  tracked; use `:Lazy update` to advance revisions and `:Lazy restore` to
  reproduce the lock.
- `archive/` is reference-only; edit it only when explicitly requested.

## Apply and Verify

- `./scripts/bootstrap.sh` installs packages, links configs, and installs Fish plugins.
- `./scripts/link.sh` installs config and agent links. Run it when adding,
  removing, or changing an installation path; existing linked-file edits apply directly.
- `fish scripts/install-fish-plugins.fish` applies `fish/fish_plugins`.
- `brew bundle check --file Brewfile` checks package dependencies.
- `./scripts/audit-agent-config.sh` checks agent links, metadata, persona pairs,
  invocation and read-only policy parity, stale references, and generated state.
  It needs Ruby/Psych, yq, and jq, and runs git-secrets when installed.

Run the checks for the changed area:

```sh
fish -n fish/config.fish fish/conf.d/*.fish
for f in fish/functions/*.fish; do fish -n "$f" || exit 1; done
stylua --check nvim/lua
jq empty nvim/lazy-lock.json
nvim --headless '+lua print("nvim-config-ok")' +qa
```

## Repository Preferences

- Use Git only; do not install, invoke, or recommend Jujutsu. Inspect
  `git status` and `git diff`; stage only intended paths and commit or push only
  when requested. Use concise conventional commits.
- Do not track sessions, logs, caches, credentials, local settings, or generated
  state. Run `git secrets --scan` before publishing agent or history-derived assets.
- Short/default aliases stay guarded unless the source records a user-approved
  exception. The `c` and `cx` abbreviations in `fish/config.fish` must retain
  their permission-bypass expansions. Other bypasses and destructive operations
  need explicit names and verified targets.
- Do not replace standard commands with Fish functions that implement a different
  CLI. Prefer maintained Rust tools for interactive ergonomics and expose
  incompatible replacements as visible abbreviations.
