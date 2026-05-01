---
name: add-package
description: |
  Add a package to this Home Manager dotfiles repo. Use when the user asks
  to install, add, or migrate a package — examples "add jq", "ripgrep を入れて",
  "lazygit 入れたい", "brew install foo を Nix に移したい", "uv を Nix で",
  "kubectl 追加して". The skill picks the right module under `home/`, checks
  nixpkgs and `programs.<X>` availability, edits the Nix file, validates
  with `home-manager build`, applies via `home-manager switch`, and verifies
  the binary resolves through Nix.
---

# add-package

Add a package to the Home Manager dotfiles config in the right place.

## Repo module layout

- `home/default.nix` — sessionVariables, `programs.nh`, ghostty link, base nix settings
- `home/fish.nix` — fish + atuin/direnv/zoxide/mise/carapace integrations
- `home/git.nix` — git/delta/gh/lazygit + ghq + power_pull
- `home/neovim.nix` — `programs.neovim` + `nvim/` symlink
- `home/packages.nix` — `programs.bat` + general `home.packages`

Non-nixpkgs sources (3 fish plugins) live as flake inputs in `flake.nix`.

## Decision flow

1. **Identify the package** (e.g. "ripgrep" → `pkgs.ripgrep`).

2. **Check availability**:
   - `nix search nixpkgs <name>` (or `nix-env -qaP <name>`) confirms it
     exists.
   - GUI app / macOS cask / not in nixpkgs → keep on brew, note why.

3. **Pick the HM home**:
   - HM has `programs.<X>` module (e.g. `bat`, `gh`, `git`, `delta`,
     `atuin`, `direnv`, `zoxide`, `mise`, `carapace`, `lazygit`, `nh`,
     `neovim`, `fish`) → enable the module so config is declarative too.
     If it integrates with fish, set `enableFishIntegration = true`.
   - Else `home.packages`.

4. **Pick the file**:
   - Tool integrates with fish (atuin/direnv/zoxide/mise/carapace/...) →
     `home/fish.nix`
   - Git / GitHub ecosystem → `home/git.nix`
   - Neovim-related → `home/neovim.nix`
   - General CLI → `home/packages.nix`
   - Don't spread `home.packages` across modules; prefer `packages.nix`
     unless the tool's `programs.<X>` block already lives elsewhere
     (then keep them together).

5. **Edit** with `Edit` tool. Keep alphabetical order within each grouped
   list (matches the existing style; `bat eza fd fzf ripgrep` etc.).

6. **Validate**: `home-manager build --flake .#nwiizo`. On error, inspect
   and fix; do **not** switch on a failed build.

7. **Apply**: `home-manager switch --flake .#nwiizo`.

8. **Verify**: `type -p <name>` resolves to `~/.nix-profile/bin/<name>`
   (or, for `programs.<X>`, the binary still works and any generated
   config is in place).

9. **If migrating from brew**: ask the user before `brew uninstall <name>`.
   Some users want the brew copy as a fallback.

## Discover migration candidates

When the user asks what to migrate from brew:

```sh
comm -13 \
  <(brew list --formula | sort -u) \
  <(ls ~/.nix-profile/bin/ | sort -u)
```

- Skip `brew list --cask` (GUI apps stay on brew).
- Prefer tools with a `programs.<X>` HM module — declarative config wins.
- For tools with non-trivial config, check if the HM module exposes
  `settings` so the existing `~/.config/<tool>/...` can be translated.

## Don't

- Don't add a package twice (e.g. via both `home.packages` and
  `programs.<X>.enable`).
- Don't auto-`brew uninstall` without explicit confirmation.
- Don't skip `home-manager build` validation.
- Don't add packages directly to `home/default.nix` — pick a domain
  module (`packages.nix`, `git.nix`, ...).
- Don't reformat unrelated parts of the file. After editing, run
  `nix fmt -- --check ./home/<file>.nix` if a format check is needed.
