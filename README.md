# dotfiles

Personal macOS development environment. Homebrew owns binaries; this repo owns
config files through direct symlinks.

## Start Here

This repo has three responsibilities:

1. Install binaries with Homebrew via `Brewfile`.
2. Keep app and CLI config in repo-owned source files.
3. Link those source files into macOS config locations.

For a new machine:

```bash
cd ~/ghq/github.com/nwiizo/dotfiles
./scripts/bootstrap.sh
```

For an existing machine after editing config:

```bash
./scripts/link.sh
fish scripts/install-fish-plugins.fish
brew bundle check --file Brewfile
```

## Documentation Map

Read this file for the overall model. Use the subdirectory docs when changing a
specific tool:

| Area | Start here | Edit mostly |
|---|---|---|
| Packages | `Brewfile` | `Brewfile` |
| Linking/bootstrap | `scripts/link.sh`, `scripts/bootstrap.sh` | `scripts/` |
| Fish | `fish/README.md` | `fish/config.fish`, `fish/functions/`, `fish/fish_plugins` |
| Neovim | `nvim/README.md` | `nvim/lua/config/`, `nvim/lua/plugins/` |
| Ghostty | `ghostty/README.md` | `ghostty/config` |
| Warp | `warp/README.md` | `warp/keybindings.yaml`, `warp/themes/`, `warp/workflows/` |
| Git / GitHub CLI | `git/README.md` | `git/config`, `git/power_pull.sh`, `gh/config.yml` |
| Small CLI configs | this README | `bat/`, `atuin/`, `tealdeer/` |
| Agent config | `.agents/README.md` | reusable agents, rules, docs, and skills |
| Claude Code entrypoints | `.claude/README.md` | symlinks into `.agents/` |
| Codex entrypoints | `.codex/README.md` | symlinks into `.agents/codex/` |

Agent-facing repository rules are in `AGENTS.md`; `CLAUDE.md` points Claude
Code at the same rules.

## Managed Stack

| Layer | Owner | Files |
|---|---|---|
| Packages | Homebrew | `Brewfile` |
| Shell | Fish + Fisher | `fish/config.fish`, `fish/functions/`, `fish/fish_plugins` |
| Editor | Neovim + LazyVim | `nvim/` |
| Terminals | Ghostty, Warp | `ghostty/config`, `warp/` |
| GitHub / Git | gh, git-delta, lazygit | `gh/config.yml`, `git/config`, `git/power_pull.sh` |
| CLI config | bat, atuin, tealdeer | `bat/config`, `atuin/config.toml`, `tealdeer/config.toml` |
| Linking / bootstrap | Shell scripts | `scripts/bootstrap.sh`, `scripts/link.sh` |
| Agent config | Claude / Agents | `.agents/` |

## Repository Layout

```text
dotfiles/
├── Brewfile                 # Homebrew formulae and casks
├── scripts/
│   ├── bootstrap.sh         # brew bundle + symlink + fish plugin install
│   ├── link.sh              # symlink repo config into target locations
│   └── install-fish-plugins.fish
├── fish/                    # Fish init, functions, plugins, conf.d patch
├── nvim/                    # LazyVim based Neovim config
├── ghostty/                 # Ghostty terminal config
├── warp/                    # Warp keybindings, themes, workflows
├── git/                     # Git config and helper scripts
├── gh/                      # GitHub CLI config
├── .agents/                 # Reusable agent config linked into ~/.claude and ~/.agents
├── .claude/                 # Claude Code project symlinks into .agents
├── .codex/                  # Codex project symlinks into .agents/codex
├── bat/                     # bat config
├── atuin/                   # atuin config
├── tealdeer/                # tealdeer config
└── archive/                 # retired configs, reference only
```

## Setup

Bootstrap a new machine after installing Homebrew:

```bash
cd ~/ghq/github.com/nwiizo/dotfiles
./scripts/bootstrap.sh
```

The bootstrap script runs:

```bash
brew bundle --file Brewfile
./scripts/link.sh
fish scripts/install-fish-plugins.fish
```

Run individual steps when you only need one layer:

```bash
brew bundle --file Brewfile
./scripts/link.sh
fish scripts/install-fish-plugins.fish
```

## Linked Paths

`scripts/link.sh` replaces existing symlinks and backs up non-symlink targets
under `~/.dotfiles-link-backups/pre-dotfiles-link-*` before linking.

| Repo path | Target path |
|---|---|
| `fish/config.fish` | `~/.config/fish/config.fish` |
| `fish/conf.d/zz_sponge_compat.fish` | `~/.config/fish/conf.d/zz_sponge_compat.fish` |
| `fish/functions/*.fish` | `~/.config/fish/functions/*.fish` |
| `nvim/` | `~/.config/nvim` |
| `ghostty/config` | `~/.config/ghostty/config` |
| `bat/config` | `~/.config/bat/config` |
| `atuin/config.toml` | `~/.config/atuin/config.toml` |
| `tealdeer/config.toml` | `~/.config/tealdeer/config.toml` |
| `git/config` | `~/.config/git/config` |
| `gh/config.yml` | `~/.config/gh/config.yml` |
| `git/power_pull.sh` | `~/.local/bin/power_pull` |
| `scripts/audit-agent-config.sh` | local validation helper |
| `scripts/summarize-ai-history.py` | local AI-history aggregate helper |
| `warp/keybindings.yaml` | `~/.warp/keybindings.yaml` |
| `warp/themes/*.yaml` | `~/.warp/themes/*.yaml` |
| `warp/workflows/*.yaml` | `~/.warp/workflows/*.yaml` |
| `.agents/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `.agents/RTK.md` | `~/.claude/RTK.md` |
| `.agents/claudeignore` | `~/.claude/.claudeignore` |
| `.agents/agents/` | `~/.claude/agents`, `~/.agents/agents` |
| `.agents/docs/` | `~/.claude/docs`, `~/.agents/docs` |
| `.agents/rules/` | `~/.claude/rules`, `~/.agents/rules` |
| `.agents/skills/*` | `~/.claude/skills/*`, `~/.agents/skills/*` |
| `.agents/codex/agents/*.toml` | `~/.codex/agents/*.toml` |
| `.claude/agents`, `.claude/rules`, `.claude/skills` | project symlinks into `.agents/` |
| `.codex/agents` | project symlink into `.agents/codex/agents` |

## Daily Workflow

Most edits happen in the repo, then the owning app or shell is restarted.

| Change | Apply |
|---|---|
| Existing Fish config or function | Open a new shell, or run `exec fish` |
| Add/remove `fish/functions/*.fish` | Run `./scripts/link.sh` |
| Fish plugins | Edit `fish/fish_plugins`, then run `fish scripts/install-fish-plugins.fish` |
| Neovim config | Restart Neovim |
| Ghostty, Warp, Git, gh, bat, atuin, tealdeer config | Restart the app or open a new shell |
| Warp workflows/themes | Run `./scripts/link.sh`, then restart Warp if needed |
| Homebrew packages | Edit `Brewfile`, then run `brew bundle --file Brewfile` |

The `update_all` Fish function updates common tools sequentially by default and
streams updater output so confirmation prompts are visible. Use `--parallel` or
`--non-interactive` when prompts should be disabled. Mac App Store updates are
skipped by default.

```bash
update_all
update_all --parallel
update_all --non-interactive
update_all --no-brew
update_all --no-rust
update_all --no-nvim
update_all --with-mas
update_all --help
```

## Change Guide

| You want to change ... | Edit | Apply |
|---|---|---|
| Shell env, PATH, abbreviations, fzf defaults | `fish/config.fish` | new shell or `exec fish` |
| Fish helper command | `fish/functions/*.fish` | `./scripts/link.sh` if adding/removing files |
| Fisher plugins | `fish/fish_plugins` | `fish scripts/install-fish-plugins.fish` |
| Neovim plugin or keymap | `nvim/lua/...` | restart Neovim |
| Ghostty | `ghostty/config` | restart Ghostty |
| Warp keybindings/theme/workflow | `warp/...` | `./scripts/link.sh`, then restart Warp if needed |
| Git / gh | `git/config`, `gh/config.yml` | new shell or next command invocation |
| Homebrew package | `Brewfile` | `brew bundle --file Brewfile` |
| Shared agent config | `.agents/`, `.claude/`, `.codex/` | `./scripts/link.sh` |

## Fish

`fish/config.fish` defines XDG paths, Homebrew paths, language tool paths,
environment variables, abbreviations, fzf defaults, and integrations for
zoxide, mise, carapace, atuin, and direnv.

Notable bindings:

| Key | Action |
|---|---|
| `Ctrl+G` | Select a ghq repository |
| `Alt+J` | Select a jj/ghq repository |
| `Ctrl+B` | Select a Git branch |
| `Ctrl+F` | fzf directory search |
| `Ctrl+L` | Clear screen |
| `Tab` | History completion on empty command line |

Common abbreviations:

```bash
g=git        gst='git status'        gaa='git add --all'
gc='git commit -v'                   gcm='git commit -m'
gp='git push'                        gpl='git pull'
d=docker     dc='docker compose'     k=kubectl
c='claude --dangerously-skip-permissions'
cbare='claude --bare'                csafe='claude --safe-mode'
cdoc='claude doctor'                 cagents='claude agents'
cx='codex --dangerously-bypass-approvals-and-sandbox'
cxs='codex --sandbox workspace-write --ask-for-approval on-request'
cxro='codex --sandbox read-only'     cxe='codex exec'
cxr='codex resume'                   cxrev='codex review --uncommitted'
v=nvim       lg=lazygit              repo=ghq_fzf_repo
actx=ai_context                      actxc='ai_context | pbcopy'
```

See `fish/README.md` for the directory contract.

## Neovim

`nvim/` is a LazyVim based configuration for Rust, Go, TypeScript, Python,
Terraform, Lua, Bash, Zig, HTML/CSS, and AI-assisted coding.

Configuration layout:

- `nvim/lua/config/`: LazyVim bootstrap, options, keymaps, autocmds
- `nvim/lua/plugins/`: feature-grouped plugin specs
- UI: catppuccin mocha, no statusline, `incline.nvim`, `noice.nvim`,
  `snacks.nvim`, `oil.nvim`, `overlook.nvim`
- Completion: `blink.cmp`
- AI: CopilotChat, Avante, CodeCompanion, Codex, Claude Code
- Git: gitsigns, Diffview, LazyGit, gitlinker
- Rust: rustaceanvim, crates.nvim, neotest, DAP

See `nvim/README.md` for plugin layout, LazyVim Extras, and keymaps.

## Terminals

Ghostty is the primary terminal config in `ghostty/config`.

- Hack Nerd Font Mono, 24pt
- Catppuccin Mocha palette
- Fish shell integration
- Vim-style pane navigation with `Ctrl+H/J/K/L`
- AI-friendly scrollback and screen dump bindings
- Split zoom, split equalization, and resize-mode bindings

Warp config is also managed here for Agent Mode, block-based output, notebooks,
Warp Drive, and reusable workflows. See `warp/README.md`.

## Validation

Run the checks that match the files you changed.

```bash
./scripts/link.sh
fish scripts/install-fish-plugins.fish
brew bundle check --file Brewfile
./scripts/audit-agent-config.sh
```

```bash
fish -n fish/config.fish
for f in fish/functions/*.fish; do fish -n "$f" || exit 1; done
```

```bash
stylua --check nvim/lua
nvim --headless '+lua print("nvim-config-ok")' +qa
```

```bash
nvim --headless '+lua require("lazy").load({ plugins = { "CopilotChat.nvim", "avante.nvim", "codecompanion.nvim", "claudecode.nvim" } }); print("ai-plugins-ok")' +qa
```

## Local State

These files are intentionally not tracked:

- `~/.config/fish/fish_variables`
- `~/.config/fish/local.fish`
- shell history and Atuin databases
- Warp `settings.toml`
- tool caches, runtime state, and secrets

## Troubleshooting

```bash
exec fish
fish --profile-startup /tmp/fish.prof -c exit
nvim --startuptime /tmp/nvim.log
```

Inside Neovim:

```vim
:Lazy sync
:Mason
:checkhealth
:LspInfo
```
