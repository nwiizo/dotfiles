# Security Rules

- Keep credentials, sessions, logs, and generated local state out of tracked configuration. Do not hardcode secrets.
- Keep permission-bypass modes explicitly named. Short/default aliases stay guarded unless the repository records the user's exception; preserve the documented `c` and `cx` expansions in `fish/config.fish`.
- Resolve the exact target and recovery path before destructive reset, prune, or deletion operations. Ordinary authorized, reversible edits do not need another approval.
- Respect branch protection. Before authorized publication, inspect the diff and run checks appropriate to the changes; this does not require a fixed reviewer roster or a new approval round.
