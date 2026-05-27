#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required: https://brew.sh" >&2
  exit 1
fi

brew bundle --file "$repo/Brewfile"
"$repo/scripts/link.sh"

if command -v fish >/dev/null 2>&1; then
  fish "$repo/scripts/install-fish-plugins.fish"
fi

echo "Bootstrap complete."
