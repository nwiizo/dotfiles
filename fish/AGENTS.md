# Fish Configuration

Read `README.md` for current workflows, plugin choices, and bindings.
Maintain Fish-specific agent guidance here; `CLAUDE.md` is a relative symlink
to this file. Root `AGENTS.md` supplies shared repository rules.

## Edit and Apply

- Use `config.fish` for environment variables, abbreviations, and interactive
  integrations; `functions/<name>.fish` for autoloaded commands; `conf.d/` for
  early setup and vendor-hook overrides.
- `../scripts/link.sh` links individual functions and snippets, leaving
  neighboring files for Fisher. Run it when adding or removing installed files;
  instruction files and tests are not installed into Fish.
- Existing linked-file edits need no relinking. Use a new shell or `reload`
  after applying changes; the once-per-shell guard skips repeated
  `source config.fish`.
- Keep credentials and machine-specific settings in `~/.config/fish/local.fish`.
  It also runs in non-interactive shells, so guard UI-only code inside it.
- Preserve standard commands' script behavior. Use visible abbreviations for
  incompatible replacements and document the command mapping in `README.md`.
  Follow the root guide's guarded defaults and explicit `c`/`cx` exceptions.

## Initialization and State

`conf.d` runs before `config.fish`, including in non-interactive shells. Guard
UI, prompt, bindings, and interactive shell hooks with `status is-interactive`.
Put paths needed by later snippets in `conf.d/00-paths.fish`. A same-named user
snippet replaces a vendor snippet; preserve and explain the mise/direnv
overrides. See [Fish's loading order](https://fishshell.com/docs/current/language.html#configuration-files).

Use [`fish_add_path --path`](https://fishshell.com/docs/current/cmds/fish_add_path.html)
for repository-managed PATH entries. Keep repository policy out of universal
`fish_user_paths`, and never edit `fish_variables` manually. Use full version
manager activation interactively and shims for non-interactive commands when
supported.

Cache only static generated integration code. Cache keys must cover executable
path, modification time, and init arguments. Do not cache directory-dependent
output such as `direnv export` or `mise hook-env`; cache the hook invoking it.
Keep histories, caches, and generated files outside Git.

## Plugins and Bindings

Keep reviewed tags or commits in `fish_plugins`. From the repository root, run
`rtk proxy fish scripts/install-fish-plugins.fish` to apply that list, then reload
existing shells. Let [Fisher's manifest workflow](https://github.com/jorgebucaran/fisher#using-your-fish_plugins-file)
reconcile exact refs; do not write `_fisher_plugins` or file inventories by hand.
The live manifest is generated, not a symlink to the repo's desired list.
Keep Sponge and `conf.d/zz_sponge_compat.fish` compatible; in-process
`fisher update` can replace the compatibility functions until a new shell starts.

Before adding a plugin, compare Fish core and existing integrations: Television
owns pickers and empty-line Tab, Atuin records history, zoxide ranks directories,
mise manages tool versions, direnv manages project environments, and Ghostty
handles long-command notifications. Check maintenance and open compatibility
issues; add a plugin when it fills a concrete gap. For new CLI tools, follow the
Rust-first selection policy in `README.md` and track binaries in `Brewfile`.

Put user bindings in `functions/fish_user_key_bindings.fish` and prefer Fish's
[named keys and input functions](https://fishshell.com/docs/current/cmds/bind.html).
Check the effective binding after the first prompt, when Fish initializes the
keymap. Preserve one owner per shortcut instead of loading overlapping hooks.
Fish history filters and Sponge do not filter Atuin's separate database.

## Verify

Run these checks from the repository root, selecting the affected behavior:

| Change | Check |
|---|---|
| Fish source | `rtk proxy fish -n` on each changed `.fish` file |
| Plugin installer | `rtk proxy fish --no-config fish/tests/install_plugins.fish` |
| Prompt | `rtk proxy fish --no-config fish/tests/prompt.fish` |
| Television helpers | `rtk proxy fish --no-config fish/tests/television.fish` |
| Tool updater | `rtk proxy fish --no-config fish/tests/update_all.fish` |

The installer check uses the installed Fisher, local fixture plugins, and an
isolated home without network access. For plugin changes, also apply the
installer, compare `fisher list` with the desired list, and exercise affected
bindings or event handlers; `fish -ic` alone does not establish their behavior.
For agent instruction changes, run `rtk proxy ./scripts/audit-agent-config.sh`.

For startup-sensitive changes, check interactive and non-interactive shells.
When changing PATH or hook dependencies, also check a minimal inherited PATH.
Benchmark when startup performance is requested or a regression is suspected:
use Fish's startup profiler or the installed benchmark tool, warm caches, run
comparisons sequentially, and inspect variance before attributing a difference.
