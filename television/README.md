# Television

Television `0.15.9` is installed through `Brewfile`. Fish and Neovim share
`config.toml` and the reviewed channels under `cable/`, linked individually by
`scripts/link.sh`. Runtime state stays outside the repository.

## Controls

| Key | Action |
|---|---|
| `Ctrl-J/K` or arrows | Move between matches |
| `Tab` / `Shift-Tab` | Select multiple entries (single selection for branch/context/container/zoxide helpers) |
| `Enter` | Accept the selection |
| `Esc` / `Ctrl-C` | Cancel |
| `Ctrl-O` / `Ctrl-/` | Toggle preview |
| `Ctrl-F` inside a picker | Cycle previews (for example worktree/staged changes) |
| `PageUp` / `PageDown` | Scroll preview |
| `Ctrl-U` / `Ctrl-D` | Scroll preview by half a page |
| `Ctrl-L` | Switch horizontal/vertical layout |
| `Ctrl-H` | Show key help |
| `Ctrl-T` inside standalone `tv` | Switch channels |

Shell `Ctrl-F`/`ff` searches files and directories. A path ending in `/` scopes
that search to the specified directory, including paths outside the project.
Shell `Ctrl-T` uses Television's command-to-channel mapping: `git switch `
selects branches, `git add ` selects changed files, `cd ` selects directories,
and `nvim ` selects files. Selection inserts escaped arguments without running
the command. Shell wrappers lock the selected channel to keep its output type
consistent. Plain `tv` keeps the channel switcher available.

Hidden files are included, `.git` and `node_modules` are excluded, and normal
ignore rules remain active. Previews quote embedded apostrophes before passing
paths to bash. Query history is disabled because Fish and Atuin already manage
command history. No community channel download is required.

## Neovim

The native bridge in `nvim/lua/config/television.lua` runs Television in a
floating terminal. It keeps stdout in a temporary file, restores the originating
window, and deletes temporary files on exit. This avoids parsing terminal screen
contents as selected paths. Search cwd is passed to the child process; the
editor's cwd stays unchanged. No additional Neovim plugin is needed.

| Key | Action |
|---|---|
| `Ctrl-P`, `<leader>ff` | Project files |
| `<leader>fF` | Files in the editor cwd |
| `<leader>fc` | Neovim config files |
| `<leader>/`, `<leader>sg` | Project text |
| `<leader>sG` | Text in the editor cwd |
| `<leader>gT` | Staged, unstaged, and untracked paths |
| `zf` in quickfix/location list | Filter that list |

Inside a file/text picker, Enter opens the first selection and adds other selections as
buffers; `Ctrl-S`/`Ctrl-V` open a split and `Ctrl-Q` sends selections to quickfix.
Text search filters streamed ripgrep matches using Television's search syntax.
It is not a live regex query passed back to ripgrep.

Quickfix/location-list search previews buffer contents through Television and
bat. Loaded buffers are captured when the picker opens, including unsaved text;
unloaded files are read on demand. Reopen the picker to refresh its cached
previews after editing. Enter on one item jumps to it; selecting several items
creates a filtered list, using nvim-bqf's existing jump and filter operations.
Diagnostic fields, custom display, list context and original ordering are
preserved, and `:colder` / `:lolder` restores the previous list. Changes made
while the picker is open are protected from replacement.

| Key inside quickfix search | Action |
|---|---|
| `Enter` | Jump to one item, or filter to multiple selected items |
| `Ctrl-X` / `Ctrl-S`, `Ctrl-V`, `Ctrl-T` | Open one item in a split, vertical split or tab |
| `Ctrl-Q` | Toggle nvim-bqf signs for selected items |
| `Ctrl-O` / `Ctrl-/` | Toggle preview |
| `Ctrl-U` / `Ctrl-D` | Scroll preview |
| `Esc` | Return to the quickfix window |
| `Ctrl-C` | Close both picker and quickfix window |

LSP, buffers, help, and other editor-specific pickers continue to use Snacks.

## Feature review

The migration was compared with the former Fish functions, fzf.fish, Snacks,
fff, and nvim-bqf behavior. Features specific to the existing tools keep their
original keys:

| Workflow | Result |
|---|---|
| `repo`, `gb`, `kc`, `de` and bindings | Television; guarded branch/context/container operations retained |
| Shell file/directory search | Restored both kinds of entry, directory-prefix scoping and previews |
| Git log | Full history, author/date search and full commit hashes retained |
| Changed paths | Staged and unstaged previews separated; untracked files included |
| Process search | Full command arguments and resource/parent-process preview retained |
| Fish history | Session merge outside private mode, timestamps, multiline preview and multiple selection; selection does not execute it |
| Variables | Caller-scope names, full values and scope/export details; `$` prefixes retained |
| `zi` / `z` completion | Ranked Television selection and directory preview; `z` completes paths or jumps interactively after keywords |
| `<leader><leader>` | Snacks Smart Picker retains buffers/recent files alongside project files |
| `<leader>fP`, `<leader>sF` | fff retains typo tolerance, frecency and live plain/regex/fuzzy search |
| `<leader>gC` | Snacks retains staging/restore actions; `<leader>gT` adds the Television view |
| `<leader>sq` | Snacks retains quickfix browsing; `zf` is the Television filter |

Television 0.15.9 has no action to toggle every matched item at once. Use `Tab`
to select matches; for bulk signs, return to quickfix and use visual selection
with `Tab` (`ggVG<Tab>` for the whole list), then `zn` / `zN` to filter signed /
unsigned items. The former in-picker `Ctrl-O` bulk toggle is an upstream gap.
Picker keys follow the controls above; they are not identical to fzf's.

Television 0.15.9 emits newline-separated selections. File names containing
literal newlines are not supported by the shell/editor handoff; text preview
also expects the usual `file:line:column` format without colons in file names.

## Validate

```sh
rtk proxy tv --config-file television/config.toml --cable-dir television/cable list-channels
rtk proxy fish --no-config fish/tests/television.fish
rtk proxy nvim --headless -u NONE -l nvim/tests/television.lua
rtk proxy nvim --headless -u NONE -l nvim/tests/television_quickfix.lua
rtk proxy brew bundle check --file Brewfile
```

Also exercise the actual TUI after changing previews or bindings. Open a new
Fish shell (`exec fish`) and restart Neovim after changing their integrations.

The quickfix checks use the installed nvim-bqf and the real Television TUI.
They cover single and multiple selection, unsaved buffer previews, revisiting
selections, signs, split/tab actions, cancellation, and list metadata/history. The Fish checks
also exercise actual history parsing and quoted previews.

`fzf` is absent from `Brewfile` and the Fisher plugin list. Homebrew's `mycli`
formula depends on it; keeping that package installed would reinstall fzf
during dependency maintenance. This environment removes both packages.

References: [shell integration](https://alexpasmantier.github.io/television/user-guide/shell-integration/),
[configuration](https://alexpasmantier.github.io/television/user-guide/configuration/),
[channel definitions at 0.15.9](https://github.com/alexpasmantier/television/tree/0.15.9/cable/unix).

## Final TODO: upstream contributions

- [ ] After the migration and feature review, prepare feature PRs suitable for
  [alexpasmantier/tv.nvim](https://github.com/alexpasmantier/tv.nvim). Review its
  latest code and existing issues/PRs before choosing the scope.
- [ ] Evaluate per-picker cwd, structured selection capture independent of the
  terminal screen, and list input/quickfix integration. Preserve cancellation,
  originating-window handling and temporary-file cleanup; include focused tests.
- [ ] Review a bulk-selection action for Television itself, so quickfix search
  can toggle all matches without leaving the picker. Keep this separate from
  tv.nvim changes and check existing issues and PRs before implementation.
- [ ] Check Television's preview-cache configuration upstream: in 0.15.9 the
  CLI's default `cache_preview = true` overrides a channel's `cached = false`.
  Review existing reports before proposing a fix; the current bridge uses
  content previews that remain valid when a cached entry is revisited.
- [ ] Before creating each PR, apply
  [`nwiizo-coding-style`](../.agents/skills/nwiizo-coding-style/SKILL.md) to the
  final diff: reuse existing APIs, remove unnecessary abstractions, preserve
  behavior and error handling, and complete the relevant checks. Review the
  actual upstream implementation rather than copying the dotfiles bridge as-is.
- [ ] Use the `nwiizo` Git/GitHub identity for commits and pushes, verifying the
  author and destination first.

These are follow-up tasks; no upstream PR has been published by this migration.
