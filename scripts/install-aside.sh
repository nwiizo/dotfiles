#!/usr/bin/env bash
set -euo pipefail

aside_bin="${ASIDE_CLI_BIN_DIR:-$HOME/.local/bin}/aside"
if [[ -x "$aside_bin" ]]; then
  "$aside_bin" --version
  exit 0
fi

installer="$(mktemp)"
trap 'rm -f "$installer"' EXIT

curl -fsSL https://releases.aside.com/install.sh -o "$installer"
bash "$installer"
"$aside_bin" --version
