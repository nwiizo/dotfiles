# Claude account switching with cctx

Use this note when configuring or debugging this machine's cctx integration.
The maintained CLI lives at `~/ghq/github.com/nwiizo/cctx`; read its README and
`docs/e2e.md` for command details and real-account test prerequisites. Check the
installed command's `--help` and version before applying these observations.

## Intended behavior

- Fish setup is maintained in dotfiles `fish/config.fish`. It loads
  `cctx --shell-init fish | source` for interactive shells. New shells load the
  integration; an existing shell needs that command once. Selection changes the
  current shell's environment, not a globally saved account preference.
- `cctx --accounts` lists profiles. There is no `list --account` subcommand.
- `cctx --account secondary` selects a login in the current shell. The user runs
  `claude` separately; do not add automatic session startup or a global switch.
- Account selection and settings contexts are distinct: `cctx work` selects
  saved settings; `cctx --account work` selects an account. Authentication and
  scoped settings operations do not select an account in the parent shell.

## Observed integration pitfalls

Verified on macOS with Claude Code 2.1.278: returning to `default` must **unset**
`CLAUDE_CONFIG_DIR`. Explicitly setting it to `~/.claude` made Claude use a
different global state file and fail to find the original login. Do not treat
an unset variable and the apparent default path as equivalent without testing
the installed Claude version.

Named profiles use stable, canonical directories under `~/.cctx/accounts/`.
Claude manages their credentials, including directory-scoped Keychain entries.
Do not copy credentials, rename logged-in profile directories, or share mutable
history/state to make switching work. Newly created profiles do not inherit the
default profile's rules, skills or plugins. If sharing guidance is requested,
choose the specific maintained, non-secret files; do not link the whole profile.

Inherited authentication variables or managed settings can override the selected
login. Diagnose using variable names and `claude auth status --text`, without
printing secret values. Browser login and any pasted authorization code belong
in the user's own terminal.

## Verify the configured workflow

Use the shell function for selection and then plain `claude auth status --text`
to verify which account a normal launch would use. `cctx --account NAME --status`
alone verifies only the explicitly scoped authentication command. When real E2E
is requested, follow the repository's opt-in test to check both identities and
responses, then restore the original selection in that test shell. Do not log out
the user's accounts as cleanup.
