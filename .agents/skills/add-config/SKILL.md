---
name: add-config
description: Add or update shell, app, or agent configuration managed by this macOS dotfiles repository.
---

# Apply Managed Configuration

Find the repository source and its installation path in the root guide and
the area's README. Edit that source; home paths are symlinked installations.

Read only the reference for the changed area:
[Fish](references/fish.md), [Neovim](references/neovim.md), or
[Claude account switching](references/claude-accounts.md).
For agent assets, use [.agents/README.md](../../README.md).

Keep application settings, installation, and runtime state distinct.
Existing linked-file edits need no relinking. For added or removed installation
paths, inspect and update `scripts/link.sh`, then apply it.
Use `add-package` if a required binary also needs installation or Brewfile tracking.

Run the area's native validation and exercise the changed behavior.
Agent changes require `rtk proxy ./scripts/audit-agent-config.sh`.
Report reload requirements and behavior that was saved but not observed.
