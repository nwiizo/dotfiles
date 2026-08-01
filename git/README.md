# Git Configuration

This directory contains the active Git config and helper scripts linked by
`../scripts/link.sh`.

## Files

| Path | Live path | Role |
|---|---|---|
| `config` | `~/.config/git/config` | User identity, aliases, credential helpers, delta pager |
| `power_pull.sh` | `~/.local/bin/power_pull` | Fast-forward-only pull helper for the current branch |

GitHub CLI config lives next door in `../gh/config.yml` and is linked to
`~/.config/gh/config.yml`.

## Config Highlights

- User identity is `nwiizo <syu.m.5151@gmail.com>`.
- `push.autoSetupRemote = true` creates upstream tracking on first push.
- Pulls are fast-forward-only and fetches prune stale remote-tracking refs.
- New repositories use `main` as the initial branch name.
- GitHub credentials are delegated to `gh auth git-credential`.
- `delta` is the pager for `diff`, `log`, `show`, and `blame`.
- `interactive.diffFilter = delta --color-only` keeps interactive staging
  readable.
- `diff.sopsdiffer.textconv = sops -d` makes encrypted SOPS files reviewable
  when `sops` is available.

## Helper Scripts

`power_pull` updates the checked-out branch without rewriting local work:

```bash
git pull --ff-only --prune
```

It refuses detached HEADs and divergent history. Use the repository's jj
workflow when working in a colocated jj repository.

## Apply

```bash
../scripts/link.sh
```

Changes are picked up by the next Git or gh invocation.
