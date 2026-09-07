# RTK - Rust Token Killer

Use RTK as the token-optimized proxy for shell commands.

## Client behavior

- Claude Code: the `PreToolUse` hook rewrites eligible Bash commands to RTK.
- Codex: start shell commands with `rtk` explicitly.
- Use `rtk proxy <cmd>` only when raw, unfiltered output is required.

## Meta Commands (always use rtk directly)

```bash
rtk gain              # Show token savings analytics
rtk gain --history    # Show command usage history with savings
rtk discover          # Analyze Claude Code history for missed opportunities
rtk proxy <cmd>       # Execute raw command without filtering
```

## Installation Verification

```bash
rtk --version         # Should show: rtk X.Y.Z
rtk gain              # Should work (not "command not found")
which rtk             # Verify correct binary
```

⚠️ **Name collision**: If `rtk gain` fails, you may have reachingforthejack/rtk (Rust Type Kit) installed instead.

Claude Code example: `git status` is rewritten to `rtk git status`.
Codex example: run `rtk git status` directly.
