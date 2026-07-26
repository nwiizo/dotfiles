# Neovim and LazyVim configuration

Read this reference for changes under `nvim/`.

## Research before framework or plugin changes

- Inspect the affected local source. When the change interacts with LazyVim
  behavior, also inspect the installed LazyVim defaults.
- When changing LazyVim, an Extra, or a plugin version, check the installed
  Neovim version, the current LazyVim stable release, and LazyVim `NEWS.md`.
- Distinguish a stable release commit from newer `main` commits that may only
  regenerate documentation. Do not infer a required config update from commit
  recency alone.
- Before importing an Extra, confirm it exists with `:LazyExtras` or in the
  installed `lazyvim/plugins/extras/` tree.

## Preserve the LazyVim model

- Keep one `require("lazy").setup()` spec in `nvim/lua/config/lazy.lua`, with
  LazyVim, Extras, and the final `{ import = "plugins" }`.
- Put feature-grouped custom specs and overrides in `nvim/lua/plugins/`. Inspect
  LazyVim and Snacks defaults before adding an autocmd, keymap, notifier, or
  plugin with overlapping behavior.
- Prefer an `opts` table for a deep-merged override. Use an `opts` function
  when existing nested values or callbacks must be preserved; chain callbacks
  such as `on_attach` instead of replacing them.
- Do not add duplicate LazyVim or lazy.nvim specs only to pin a version.
  Inspect LazyVim's own spec and record the resolved revision in
  `nvim/lazy-lock.json`.
- Read the plugin release notes when updating across a major version. Verify
  renamed APIs, new dependencies, build steps, and removed integrations.

## Track compatibility and reproducibility

- Use `vim.uv`, not deprecated `vim.loop`, for this Neovim 0.12+ config.
- Use `buf` in `vim.keymap.set` and `vim.keymap.del` options; `buffer` is
  deprecated in Neovim 0.12.
- Keep `nvim/lazy-lock.json` tracked. `:Lazy update` advances plugins and the
  lockfile, `:Lazy restore` reproduces locked revisions, and `:Lazy sync` runs
  install, clean, and update.
- Review lockfile churn with the related config change. Do not publish
  unrelated plugin updates.

## Validate

```bash
stylua --check nvim/lua
jq empty nvim/lazy-lock.json
nvim --headless '+lua print("nvim-config-ok")' +qa
nvim --headless '+checkhealth vim.deprecated' +qa
```

When a lazy-loaded integration changed, explicitly load the plugin and exercise
its changed module, command, or keymap; startup alone does not cover deferred
configuration. Run `:Lazy health` for plugin-manager failures and inspect the
`lazy-lock.json` diff before committing.

Official references:

- [LazyVim configuration](https://www.lazyvim.org/configuration)
- [LazyVim lazy.nvim setup](https://www.lazyvim.org/configuration/lazy.nvim)
- [lazy.nvim lockfile](https://lazy.folke.io/usage/lockfile)
- [Neovim deprecated APIs](https://neovim.io/doc/user/deprecated.html)
