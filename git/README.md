# Git Configuration

This directory contains the active Git config and helper scripts linked by
`../scripts/link.sh`.

## Files

| Path | Live path | Role |
|---|---|---|
| `config` | `~/.config/git/config` | User identity, aliases, credential helpers, delta pager |
| `power_pull.sh` | `~/.local/bin/power_pull` | Force-reset helper for disposable worktrees |

GitHub CLI config lives next door in `../gh/config.yml` and is linked to
`~/.config/gh/config.yml`.

## Config Highlights

- User identity is `nwiizo <syu.m.5151@gmail.com>`.
- `push.autoSetupRemote = true` creates upstream tracking on first push.
- GitHub credentials are delegated to `gh auth git-credential`.
- `delta` is the pager for `diff`, `log`, `show`, and `blame`.
- `interactive.diffFilter = delta --color-only` keeps interactive staging
  readable.
- `diff.sopsdiffer.textconv = sops -d` makes encrypted SOPS files reviewable
  when `sops` is available.

## Helper Scripts

`power_pull` is intentionally destructive:

```bash
git fetch origin
git reset --hard origin/master
```

Use it only in throwaway clones or repos where resetting to `origin/master` is
the intended operation. For normal work, prefer `git pull --ff-only` or the
repo's jj workflow.

## Apply

```bash
../scripts/link.sh
```

Changes are picked up by the next Git or gh invocation.
