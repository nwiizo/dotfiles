# Archive

Retired configuration and historical investigation records live here.
These files are reference material and are not installed or loaded as current
configuration. Read the active area's README before reusing them.

## Archived on 2026-11-06

| Location | Reason and current owner |
|---|---|
| [agent-config/](agent-config/README.md) | Former rules and retired skills; current instructions and workflows live under [`.agents/`](../.agents/README.md) |
| [agent-history/](agent-history/engineering-sources.md) | Investigation sources and adoption records, preserved separately from task instructions |
| [atuin/config.toml](atuin/config.toml) | Atuin is retired; [Fish](../fish/README.md) records history and Television provides history search |
| [fish/functions/fish_right_prompt.fish](fish/functions/fish_right_prompt.fish) | Empty right-prompt override removed from Fish's autoloaded functions |

The retired files were already deleted from the working tree. Their last
committed contents were recovered here, with one relative link adjusted for the
archived location. The two investigation records retain their existing
working-tree edits. The former `.claude/rules` symlink is not
retained because its content is preserved in `agent-config/rules/`.

## Earlier Archives

The existing `bash/`, `dockerfile/`, `lvim/`, `nvchad/`, `nvchad-v2.5/`, `ssh/`,
`starship/`, `tmux/`, `vim/`, `warp/`, and `zsh/` directories remain reference
material. [Warp's guide](warp/README.md) describes its retirement and former
installation paths.
