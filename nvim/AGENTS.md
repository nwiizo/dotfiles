# Neovim Configuration

This directory manages a LazyVim-based Neovim 0.12+ environment.
These instructions apply under `nvim/` and supplement the repository's AGENTS.md.
Read [README.md](README.md) for the current layout, keymaps, local plugin
requirements, and verification commands. `CLAUDE.md` links to this file;
edit these instructions here. Keep user-facing instructions in the README.

## Configuration boundaries

- Edit `lua/config/` for Neovim options, keymaps, and autocmds. Put plugin
  specs in the feature files under `lua/plugins/`: editing in `coding.lua`,
  display in `ui.lua`, search in `navigation.lua`, and AI clients in `ai.lua`.
- Keep one `lazy.setup()` spec in `lua/config/lazy.lua`: LazyVim, Extras,
  then the custom `plugins` import. Verify an Extra exists before importing it.
- Inspect installed LazyVim defaults before adding an override. Prefer `opts`
  for setup values; use `config` only for additional initialization. When
  changing nested tables or callbacks, preserve the defaults and chain an
  existing `on_attach`. Check list-valued options separately: append explicitly
  or use an existing `opts_extend` declaration; do not assume deep merging
  concatenates arrays. Avoid top-level `require()` calls that load plugins
  while their specs are being collected.
- Before a version change, compare the lockfile and installed revision with
  the stable release tag, `CHANGELOG.md`, and `NEWS.md`. Check the Neovim
  requirement and affected plugin APIs. Do not treat newer documentation-only
  commits on `main` as a required upgrade or add redundant version specs.
- Track `lazy-lock.json`; update only plugins needed for the task. The local
  codex, signalbox, cargo, and marp plugins use `dir` and are managed in their
  own repositories. Their working trees are not restored by the lockfile.

## Behavior to preserve

- Keep the minimal UI: no lualine or bufferline; Incline, modes, and Noice
  provide file, mode, and command information. Oil must load at startup so
  opening a directory works. better-escape loads after `User LazyVimKeymaps`
  so the first Visual selection can use `jk`.
- Television owns the usual file/text search and quickfix filtering. Snacks
  handles structured pickers; fff remains the typo-tolerant alternative.
  Telescope is available through its command and `<leader>fT`; importing the
  Telescope Extra would change the default picker and shared keys.
  Do not consolidate them without checking the operations each supplies.
- Copilot supplies inline completion (`vim.g.ai_cmp = false`), while Blink
  handles LSP completion and snippets. Avante automatic suggestions stay off
  initially. Leave format-on-save to LazyVim so `<leader>uf` keeps working;
  do not add Conform's own `format_on_save` callback.
- Keep Japanese prose free of automatic spell checking and markdownlint.
  Preserve Quicker's `edit.autosave = false`. External-change merging must
  retain unsaved edits, conflict contents, final-newline handling, and Undo.
- Use Neovim 0.12 APIs, including `vim.uv` and `buf` in keymap options.
  Refactoring uses the v2 operation APIs and `refactoring.debug`; retain
  `lewis6991/async.nvim` and the operator motions used by expression mappings.

## Keymap ownership

Keep custom leader sequences to two keys after `<leader>`. Existing LazyVim
sequences remain available. Use `<leader>a*` for the shared AI clients,
`<leader>o*` for Codex, `<leader>R*` for refactoring, and `<leader>h*` for hunks.
Rust and Cargo.toml may share `<leader>r*` through buffer-local mappings.

Declare shared AI shortcuts in the plugin's lazy.nvim `keys` spec. Keep
Avante's `auto_set_keymaps = false`; its automatic mappings can overwrite
another client's keys depending on load order. `<leader>an` rejects a Claude
diff, `<leader>aN` opens a new Avante chat, and Avante refresh/stop use
`<leader>aS` / `<leader>aX`. Keep selection hints aligned with the actual keys.

Check mode and buffer scope as well as the key sequence. Disabling a LazyVim
mapping must cover its original modes; for example, Yanky's old `<leader>p`
binding must be disabled in both `n` and `x`. Use `x` for Visual-only bindings.
Verify shared keys after the relevant plugins load, including a different
load order when it could change the result. Expression mappings that return
another plugin's text object need remapping; refactoring cleanup uses `ag`
from mini.ai and requires `remap = true`.

## Verification

Run the README's required StyLua, lockfile JSON, and headless startup checks
from the repository root. Check modified test files with StyLua as well.
Startup alone does not exercise deferred plugins: load each affected integration
and execute its changed command, module, or mapping. For API changes, also run
`:checkhealth vim.deprecated`; for Treesitter updates, run its health check.

Before tests that load AI integrations, isolate the child process's HOME and
XDG config/data/state/cache directories. Copy the config and reference installed
plugins, parsers, Mason, and the four local repositories as described in the
README. Keep authenticated AI requests out of ordinary regression tests.

Use `tests/keymap_conflicts.lua` for shared AI and Yanky key changes; the test
dispatches real keys while replacing only the external AI action. Use the
`tests/refactoring.lua` test for debug print operators and whole-buffer cleanup.
Use the other existing tests for the affected behavior, especially
`tests/external_changes.lua` for external-edit merging. Report which operations
were exercised and which still require a live service or interactive UI.

## References

For spec changes, consult [lazy.nvim's spec](https://lazy.folke.io/spec) and
[LazyVim's customization rules](https://www.lazyvim.org/configuration/plugins).
For dependency updates, use the [lockfile guide](https://lazy.folke.io/usage/lockfile)
and the release notes for the target version. The behavior and key assignments
above are this repository's choices, not universal plugin defaults.
