# dotfiles Agent Guide (Claude)

This file is for Claude Code. The canonical cross-agent guide is
[`AGENTS.md`](./AGENTS.md); keep this file aligned when changing repository
workflow rules.

See `AGENTS.md` for the complete repository guide. The same rules apply
to Claude Code; nothing is Claude-specific.

## Quick reminders

- Nix/Home Manager is no longer active in this repo. Do not add new
  `flake.nix`, `home/*.nix`, Home Manager modules, or nix-darwin config.
- Config files are symlinked by `./scripts/link.sh`; re-run it when adding
  or removing linked files.
- Packages live in `Brewfile`; Fish plugins live in `fish/fish_plugins`.
