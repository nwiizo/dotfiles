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

Add packages through Homebrew. This repo's package management is the top-level
`Brewfile`.

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
   - Keep package changes in `Brewfile`.
   - If a repo config, validation command, or agent rule requires the binary,
     keep the Homebrew-owned package explicit even when it is already installed
     transitively or outside the Brewfile.

4. Check installed dependencies before applying:

```bash
brew bundle check --file Brewfile
```

If the check reports the newly requested package as missing, continue with its
authorized installation. Distinguish that expected result from an invalid
Brewfile or an unrelated dependency problem.

5. Apply:

```bash
brew bundle --file Brewfile
```

6. Verify:

```bash
command -v <binary>
<binary> --version
brew bundle check --file Brewfile
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

The install and verification results above cover package-only changes; do not
run `brew bundle` again just to complete this section. If shell integration
also changes, use the affected Fish checks in `add-config`.

## Don't

- Do not create unrelated package management files.
- Do not run `brew uninstall` unless the user explicitly asks.
- Do not use `brew cleanup` or uninstall unrelated local packages merely to
  make the machine match the Brewfile; report that drift separately.
- Do not add a package twice under different names.
- Do not edit generated target files under `~/.config`; edit repo sources.
- Do not reformat unrelated parts of `Brewfile`.
