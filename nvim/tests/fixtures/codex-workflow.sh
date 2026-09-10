#!/bin/sh
# Deterministic terminal peer: accept bracketed requests, edit one fixture file,
# and answer twice. Never evaluate the supplied request as a shell command.
set -eu
stty -echo
paste_start=$(printf '\033[200~')
paste_end=$(printf '\033[201~')
printf 'model: fixture ready\n\033[0 q\033[?25h'
request=
while IFS= read -r line; do
  line=${line#"$paste_start"}
  case "$line" in
    *"$paste_end")
      request="$request${line%"$paste_end"}"
      printf '%s\n' "$request" >> "$1"
      case "$request" in
        *WORKFLOW_FOLLOWUP_OK*) printf '\n• WORKFLOW_FOLLOWUP_OK\n' ;;
        *)
          printf 'after\n' > example.txt
          printf '\n• WORKFLOW_EDIT_OK\n'
          ;;
      esac
      request=
      printf '\033[0 q\033[?25h'
      ;;
    *) request="$request$line
" ;;
  esac
done
