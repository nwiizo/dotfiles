#!/usr/bin/env bash
set -euo pipefail

hook_input="$(cat)"

title="$(
  jq -r '
    (.title // "Claude Code")
    | tostring
    | gsub("[[:cntrl:];]"; " ")
    | .[0:80]
  ' <<< "$hook_input"
)"
body="$(
  jq -r '
    (.message // "Needs your attention")
    | tostring
    | gsub("[[:cntrl:];]"; " ")
    | .[0:240]
  ' <<< "$hook_input"
)"

terminal_sequence="$(printf '\033]777;notify;%s;%s\007' "$title" "$body")"
jq -nc --arg sequence "$terminal_sequence" '{terminalSequence: $sequence}'
