# dotfiles Agent Guide (Claude)

This file is for Claude Code. The canonical cross-agent guide is
[`AGENTS.md`](./AGENTS.md); keep this file aligned when changing repository
workflow rules.

See `AGENTS.md` for the complete repository guide. The same rules apply
to Claude Code; nothing is Claude-specific.

## Quick reminders

- **`home-manager switch` is not always required.** `nvim/` and
  `fish/functions/*.fish` are live symlinks via `mkOutOfStoreSymlink`,
  so editing those files takes effect immediately. Run `switch` only
  when the structure changes (add/remove a file, edit `home/*.nix` or
  `flake.nix`, edit other `xdg.configFile` / `home.file` paths). The
  full table is in `AGENTS.md` → "When `home-manager switch` is required".
- For concrete recipes when adding new things, read
  [`home/HOWTO.md`](./home/HOWTO.md) and use the `add-package` /
  `add-nix-config` skills.
