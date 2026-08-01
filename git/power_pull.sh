#!/usr/bin/env bash
set -euo pipefail

if (( $# != 0 )); then
  echo "usage: power_pull" >&2
  exit 2
fi

if ! git symbolic-ref --quiet HEAD >/dev/null; then
  echo "power_pull requires a checked-out branch" >&2
  exit 1
fi

git pull --ff-only --prune
