---
name: add-package
description: |
  Add a package to this macOS dotfiles repo. Use when the user asks to
  install, add, or migrate a CLI package or GUI app, for example "add jq",
  "ripgrep を入れて", "lazygit 入れたい", "brew install foo を repo 管理に",
  "kubectl 追加して". Homebrew owns binaries here; update Brewfile, validate
  with brew bundle, apply with brew bundle, and verify the executable.
---

# add-package

Add packages through Homebrew. Nix, Home Manager, and nix-darwin are not part
of the active setup.

## Decision Flow

1. Identify the package name and whether it is a formula, cask, or non-brew
   package.

2. Check Homebrew availability:

```bash
brew search <name>
brew info <name>
```

3. Edit `Brewfile`:
   - CLI tools: `brew "<formula>"`
   - GUI apps: `cask "<cask>"`
   - Keep existing grouping and simple alphabetical order where practical.
   - Do not add Nix files or Home Manager modules.

4. Validate before applying:

```bash
brew bundle check --file Brewfile
```

5. Apply:

```bash
brew bundle --file Brewfile
```

6. Verify:

```bash
command -v <binary>
<binary> --version
```

For casks, verify with `brew list --cask <name>` or by checking the app
exists in `/Applications`.

## Non-Homebrew Packages

Use non-brew installation only when Homebrew is unavailable or inappropriate,
for example npm-only ACP adapters. In that case:

- Install with the native package manager, e.g. `npm install -g <package>`.
- Verify the exposed command with `command -v`.
- State that it is not tracked by `Brewfile` unless a Homebrew formula/cask
  exists.

## Validation

For package-only changes:

```bash
brew bundle check --file Brewfile
brew bundle --file Brewfile
```

If the package affects shell integration, also validate Fish:

```bash
fish -n fish/config.fish
for f in fish/functions/*.fish; do fish -n "$f" || exit 1; done
```

## Don't

- Do not create or edit `home/*.nix`, `flake.nix`, or nix-darwin files.
- Do not run `brew uninstall` unless the user explicitly asks.
- Do not add a package twice under different names.
- Do not edit generated/live files under `~/.config`; edit repo sources.
- Do not reformat unrelated parts of `Brewfile`.
