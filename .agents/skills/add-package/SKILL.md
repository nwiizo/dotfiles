---
name: add-package
description: Install a CLI tool or macOS application and record it in this dotfiles repository's Brewfile.
---

# Install and Track a Package

Check the requested formula or cask with `rtk proxy brew search` and
`rtk proxy brew info`; inspect the existing Brewfile for duplicates.
Keep its grouping and record directly required binaries explicitly, even when
currently installed as a transitive dependency.

Use `rtk proxy brew bundle check --file Brewfile` to identify missing packages.
Apply the authorized installation with `rtk proxy brew bundle --file Brewfile`.
A newly requested missing package is expected; distinguish unrelated failures.

Verify the binary resolved on PATH and its version, or the installed cask,
then confirm the bundle check. Reuse that result if nothing changed.
Shell integration uses the affected `add-config` checks.

If Homebrew cannot supply the requested package, use its supported installation
method within the request and state how it is tracked.
Uninstalling unrelated packages or running cleanup is outside an installation request.
