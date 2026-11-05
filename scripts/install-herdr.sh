#!/usr/bin/env bash
set -euo pipefail

install_plugins=true
case "${1:-}" in
  "") ;;
  --integrations-only) install_plugins=false ;;
  --help|-h)
    echo "Usage: install-herdr.sh [--integrations-only]"
    exit 0
    ;;
  *)
    echo "Usage: install-herdr.sh [--integrations-only]" >&2
    exit 2
    ;;
esac
if [[ $# -gt 1 ]]; then
  echo "Usage: install-herdr.sh [--integrations-only]" >&2
  exit 2
fi

if ! command -v herdr >/dev/null 2>&1; then
  echo "Herdr is required; install the repository Brewfile first." >&2
  exit 1
fi

for client in claude codex; do
  if command -v "$client" >/dev/null 2>&1; then
    herdr integration install "$client"
  else
    echo "Skipping Herdr integration: $client is not installed."
  fi
done

if [[ "$install_plugins" == false ]]; then
  exit 0
fi

plugins="$(herdr plugin list --json)"
jq -e '.result.plugins | type == "array"' <<<"$plugins" >/dev/null

install_plugin() {
  local id="$1" source="$2" ref="$3"
  if jq -e --arg id "$id" '.result.plugins | any(.plugin_id == $id)' \
      <<<"$plugins" >/dev/null; then
    echo "Keeping installed Herdr plugin: $id"
  else
    herdr plugin install "$source" --ref "$ref" --yes
  fi
}

# Reviewed installation refs. Existing installations retain their selected version.
install_plugin herdr-file-viewer smarzban/herdr-file-viewer v1.18.0
install_plugin examples.github-link-preview \
  ogulcancelik/herdr-plugin-examples/github-link-preview \
  18709cdc851dd63ed0543eb8388343a5446fd8d8
