# Fish Shell

This directory holds the Fish configuration. `scripts/link.sh`
symlinks `config.fish`, `conf.d/`, and custom functions into
`~/.config/fish/`. `fish_plugins` is the repo-managed desired plugin list;
Fisher writes `~/.config/fish/fish_plugins` when
`scripts/install-fish-plugins.fish` runs. The installer bootstraps Fisher from
a reviewed commit with a pinned SHA-256 checksum; Sponge is fixed at `1.1.0`
because the repo carries a Fish 4.x compatibility override for that release.

## Layout

| Path | Role |
|---|---|
| `config.fish` | Main shell init, abbreviations, env vars, and tool integrations |
| `fish_plugins` | Repo-managed Fisher desired plugin list |
| `functions/` | Custom fish functions (prompt, AI helpers, Git pickers, `update_all`, etc.) |
| `conf.d/` | Early PATH setup, cached mise/direnv hooks, and Fish 4.x compatibility snippets |

## How edits flow

1. Edit `config.fish`, `fish_plugins`, or files under `conf.d/` and `functions/`.
2. Run `../scripts/link.sh` when adding/removing files.
3. Run `fish ../scripts/install-fish-plugins.fish` when changing plugins.
4. New shells pick up changes; reload the shell with `exec fish`.

## Development setup (2026-09-15)

Validated with Fish `4.9.3`, the current release listed in the
[official release notes](https://fishshell.com/docs/current/relnotes.html).
It includes recent macOS keyboard-layout and IME fixes. The configuration uses
Fish 4.9's abbreviation descriptions and Fish 4.8's separate colors for builtins
and functions. Start a new shell with `reload` after editing; sourcing
`config.fish` again is skipped by its once-per-shell guard.

### Prompt and colors

The native two-line prompt shares Catppuccin Mocha colors with Ghostty and
Neovim. It highlights the repository name, shows Git changes and upstream
distance, and adds background jobs, command durations above two seconds, and
failed exit codes when relevant. For example:

```text
╭─ ~/g/g/n/dotfiles   main !⇡1  3s
╰─❯ cargo test
```

Completed commands collapse to `❯` using `fish_transient_prompt`. Directory
shortening uses native `prompt_pwd`, including its control-character handling.
With `NO_COLOR`, paths, status information, and the input marker remain visible.
The prompt uses Fish helpers and the installed Nerd Font.

Syntax colors distinguish external commands, builtins, functions, options,
quoted strings, and errors. Suggestions use a brighter gray, and completion
selections use an explicit background. Colors are global variables set in
`config.fish`, so repository settings take precedence over local universal
variables without rewriting `fish_variables`.

### Discoverable shortcuts and previews

`repo`, `gb`, `ff`, `fgl`, `fgs`, `fp`, `fh`, `gwl`, and other workflow
abbreviations include descriptions in the completion pager via
[`abbr --description`](https://fishshell.com/docs/current/cmds/abbr.html).
For example, type `rep` and press Tab to see what `repo` does.

Television uses rounded borders and Catppuccin colors shared with Ghostty.
File previews use bat; directory previews use eza's tree view. Reviewed channels
live in [`television/cable/`](../television/cable/), shared with Neovim.
Hidden files are searchable while `.git` and `node_modules` are excluded;
normal ignore files still apply.

Fish's native editing remains useful alongside the pickers:

| Shortcut | Action |
|---|---|
| `Right` at the end of input | Accept the autosuggestion |
| `Alt+F` | Accept the next suggested word |
| `Alt+E` / `Alt+V` | Edit the command buffer in Neovim |
| `Ctrl+S` while the completion pager is open | Search completion candidates |

These come from Fish's [interactive features](https://fishshell.com/docs/current/interactive.html).
Ghostty reserves `Cmd` combinations for pane navigation, leaving Fish's
`Ctrl+U`, `Ctrl+W`, and `Ctrl+L` editing actions available.

### Validation

```fish
rtk proxy fish -n fish/config.fish
rtk proxy fish -n fish/functions/fish_prompt.fish
rtk proxy fish -n fish/functions/fish_user_key_bindings.fish
rtk proxy fish --no-config fish/tests/prompt.fish
```

The prompt checks cover rendering without color, transient output, failed
commands and pipelines, and duration formatting. Also exercise the interactive
completion descriptions and Television previews after changing their settings.
Run `rtk proxy fish --no-config fish/tests/television.fish` for insertion,
multiline history, cancellation, operation arguments, and literal-path previews.

## Agent-assisted workflow

`cctx --account secondary` selects the second Claude login for this shell;
`cctx --account default` returns to the original login. cctx's Fish integration
only changes `CLAUDE_CONFIG_DIR`; start `claude` separately. Login/status commands
remain available as `cctx --account secondary --login` and `--status`.
The local cctx checkout is installed with Cargo from `~/ghq/github.com/nwiizo/cctx`.

The short aliases intentionally start unrestricted sessions: `c` expands to
`claude --dangerously-skip-permissions`, and `cx` expands to
`codex --dangerously-bypass-approvals-and-sandbox`. This is a local exception
that overrides the guarded-default convention for these two aliases. Use `cl`
for normal Claude Code permissions, `cxs` for workspace-write Codex with
approval prompts, or `cxro` for read-only Codex.

`cxq` and `cxe` both expand to `codex exec` for non-interactive tasks. Codex
0.153.4 no longer accepts the old `-q` flag. See the
[Codex configuration notes](../.codex/README.md) for current settings and checks.

| Command | Purpose |
|---|---|
| `ast` | `ast-grep` structural search and rewrite |
| `awatch <command...>` | Re-run verification whenever an agent changes files |
| `wx` | Direct `watchexec` access |
| `private` | Start `fish --private` without reading or writing history |
| `gwl` | List Git worktrees and their branches |
| `gwa -b <branch> <path>` | Create a separate working directory for an agent task |
| `gwt` | Direct `git worktree` access |

For concurrent work, `gwa -b agent/task ../project-agent` creates a new branch
and worktree; then open a shell or Neovim in that directory. Git keeps each
worktree's checkout and index separate. These abbreviations use standard
[Git worktree](https://git-scm.com/docs/git-worktree) behavior, including its
checks for branches already checked out elsewhere.

Interactive command lines visibly expand `cat`, `grep`, `ls`, `find`, and `du`
to the Rust-powered `bat`, `rg`, `eza`, `fd`, and `dust`. These are
abbreviations rather than autoloaded functions, so Fish scripts keep the native
option semantics. The shorter explicit `b` and `l` abbreviations remain
available too.

## Rust-first CLI policy

Interactive shell ergonomics deliberately favor mature Rust tools. A new
replacement should have a clear workflow benefit, substantial adoption,
recent maintenance, and a Homebrew core formula; overlapping novelty tools are
not added. Incompatible CLIs use visible Fish abbreviations rather than
autoloaded functions, so scripts retain the native commands.

| Typed command | Expanded command | Role |
|---|---|---|
| `cat` | `bat` | syntax-aware file output |
| `grep` | `rg` | fast recursive search |
| `ls` | `eza --icons --group-directories-first` | rich directory listing |
| `find` | `fd` | ergonomic file discovery |
| `du` | `dust` | visual disk usage |
| `sed` | `sd` | intuitive find and replace |
| `ps` | `procs` | modern process listing |
| `top` | `btm` | interactive system monitor |
| `ping` | `gping` | latency graph |
| `http` | `xh` | HTTPie-style requests; `curl` remains native |
| `hex` | `hexyl` | hexadecimal file viewer |
| `bench` | `hyperfine` | command benchmarking |

`rga` remains explicit because it extends `rg` to PDFs, archives, Office
documents, and other rich formats rather than replacing normal text search.

Selection snapshot on 2026-08-02: [sd](https://github.com/chmln/sd) 7.3k,
[procs](https://github.com/dalance/procs) 6.1k,
[bottom](https://github.com/ClementTsang/bottom) 13.8k,
[xh](https://github.com/ducaale/xh) 8.0k,
[ripgrep-all](https://github.com/phiresky/ripgrep-all) 9.8k,
[hexyl](https://github.com/sharkdp/hexyl) 10.2k, and
[gping](https://github.com/orf/gping) 12.6k GitHub stars. All were non-archived,
active in 2026, and available from Homebrew core when selected.

For example, keep a Rust test loop next to Claude Code or Codex:

```fish
awatch cargo test --all
```

Watchexec uses native filesystem events, respects project ignore files, and
restarts an in-flight verification when a newer edit arrives.

## File browsing with Yazi

Run `y [directory]` to browse files with [Yazi](https://github.com/sxyazi/yazi).
`Enter` opens a file, `Space` selects files, and `~` opens the key help.
Quit with `q` to keep Yazi's final directory in Fish; `Q` exits without changing
the shell directory. Use `yazi` directly when no directory handoff is needed.

The Fish wrapper follows [Yazi's shell integration](https://yazi-rs.github.io/docs/quick-start/)
and preserves a failing Yazi exit status. Its temporary cwd file is removed
after exit. Homebrew owns the binary; `functions/y.fish` owns the integration.

Selected on 2026-09-08: 42,042 GitHub stars, maintained Rust implementation,
and a Homebrew core formula. It adds interactive multi-file operations and
previews to the shell; Oil remains the Neovim file explorer. Yazi is under
active development, so check release notes when updating.

Television replaced the fzf pickers on 2026-09-15. Starship and Tide would replace
the native prompt, which remains intentionally small. Atuin records history,
zoxide ranks directories, and Fisher manages the editing plugins.

## Database browsing with rainfrog

Run `rainfrog` for a Rust-based database TUI with Vim-style navigation, a query
editor, history, favorites and a result table. It supports PostgreSQL, MySQL and
SQLite. Homebrew manages the binary through `Brewfile`; connection settings,
history and exports stay outside this repository.

Selected on 2026-09-15: version `0.4.5`, 5,332 GitHub stars, active Rust project
and a Homebrew core formula with no runtime dependencies. It replaces the local
mycli installation, whose Homebrew formula requires fzf. This is a separate
interface, so use `rainfrog` explicitly rather than aliasing `mycli` to it.
See the [upstream usage guide](https://github.com/achristmascarl/rainfrog#usage)
for connection options. Upstream treats MySQL and SQLite as tier 2 and does not
recommend production write access.

## Updating tools and handling failures

`update_all` uses each tool's native updater. Sequential and parallel modes
share the same job definitions and result handling; `--parallel` also retains
the Neovim and Mason timeouts. Each run has its own log directory.

Homebrew updates preserve unlinked, non-keg-only formulae such as TypeScript
(`Brewfile` uses `link: false` so npm can own `tsc`). Before the regular upgrade,
`brew info` and `jq` select outdated, unpinned formulae in that state and update
them with `brew install --formula --skip-link`. Plain `brew upgrade` tries to
link them again, even when they were previously unlinked. A failed metadata
check or unlinked update stops the Homebrew job before the regular upgrade.

Prompts are enabled only when both stdin and stdout are terminals, checked
at startup and again before each sequential job. Parallel
jobs and other non-interactive runs read from `/dev/null`, so they do not
inherit unusable terminal input or consume the caller's piped input.

When an updater or Homebrew cleanup fails, all remaining jobs finish before
one Codex request is made. The request includes the failed updater names and
the log directory, and asks for diagnosis, relevant repairs, and verification.
It works from this dotfiles repository, regardless of where `update_all` was
invoked. Logs are kept, and `update_all` returns `1` even if Codex exits
successfully: a completed agent session alone does not prove every updater
has recovered.

Normal terminal runs open interactive Codex with the `workspace-write` sandbox
and approval on request. `--parallel`, `--non-interactive`, or redirected input
or output uses [`codex exec`](https://learn.chatgpt.com/docs/non-interactive-mode)
with the same sandbox and no approval prompts. Non-interactive repairs that
need permissions outside that sandbox are reported as unresolved. Its output
is saved as `codex.log`, and its final response as `codex-result.md`, alongside
`codex-prompt.txt` and the update logs.

Use `update_all --no-codex` to keep failure reporting without invoking Codex.
Repair sessions also inherit a recursion guard. If Codex is missing or fails,
the update failure and logs remain available. Successful update runs do not
invoke Codex and remove their temporary logs.

Run the regression checks from the repository root:

```fish
rtk proxy fish --no-config fish/tests/update_all.fish
```

Updaters and Codex are replaced by local test commands; the checks do not
update real tools or send an AI request. To cover interactive Codex launch
selection through RTK, allocate a terminal for the test:

```fish
rtk proxy script -q /dev/null fish --no-config fish/tests/update_all.fish
```

## Interactive selection

| Shortcut | Action |
|---|---|
| `repo` / `Alt-J` / `Ctrl-G` | Select a ghq repository with Television and change directory |
| `gb` / `Ctrl-B` | Select a local Git branch and switch without forcing away changes |
| `kc` | Select a context from the local kubeconfig and make it current |
| `de [command...]` | Select a running Docker container and run the command, or `sh` by default |
| `Ctrl-T` | Choose a Television channel based on the current command |
| `ff` / `Ctrl-F` | Search files and directories with Television |
| `Ctrl-R` | Search current Fish history with Television |
| `Ctrl-Alt-L` | Browse Git commits with a diff preview |
| `Ctrl-Alt-S` | Pick changed files with a diff preview |
| `Ctrl-Alt-P` | Search running processes |
| `fh` | Search history with Atuin (synced, with stats) |
| `zi [keywords...]` | Select a frequent directory from zoxide with Television |
| Tab on an empty command line | Search history with Television |
| `Ctrl-L` | Clear the screen and redraw the prompt with Fish's built-in `clear-screen` |

Cancelling a picker leaves the branch or context unchanged and does not execute
a container command. These pickers use the installed Git, kubectl, Docker,
and Television commands. Atuin still records history and backs `fh`, but its
own `Ctrl-R` and Up-arrow bindings are disabled. `z` keeps ordinary directory
completion; Tab after search keywords opens ranked Television selection and
jumps to the chosen directory. `zi` opens that selection directly.

`repo`, `gb`, `kc`, and `de` expand to `git_tv_ghq`, `git_tv_branch`,
`kubectl_tv_ctx`, and `docker_tv_exec`. Their descriptions remain visible in
Fish completion. `fgl`, `fgs`, `fp`, and `fv` insert commits, changed paths,
process IDs, and variable names into the command buffer.

The Fish helpers merge other sessions' history outside private mode, then feed
the current shell's timestamped history to Television with NUL entry separators.
Multiline and unsaved commands remain intact, with syntax-colored previews.
Several commands can be selected with Tab; selection only edits the command
buffer, and Enter executes it. `fv` previews full variable values and their
scope/export information, including local variables at the invocation site.
Smart completion
filters paths from the current working directory; `Ctrl-F` on a directory path
ending in `/` searches that directory instead. The native `tv init fish` hook
is not also loaded, avoiding duplicate bindings and its separate history source.
See the [Television guide](../television/README.md) for picker controls.

Bindings use Fish's [named keys and input functions](https://fishshell.com/docs/current/cmds/bind.html).
No external `clear` process is needed to redraw the prompt.

## Startup behavior

For Claude Code troubleshooting, `csafe` preserves normal authentication while
disabling personal customizations. `cbare` requires an API key or `apiKeyHelper`
because bare mode skips OAuth and keychain authentication. Configuration choices
and validation commands are documented in the [Claude Code guide](../.claude/README.md).

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
- Tool caches and histories (`atuin`, `television`, shell history).

## Editing Rules

- Do not edit `~/.config/fish/config.fish` directly.
- Define `fish_prompt` and `fish_right_prompt` only under `fish/functions/`.
