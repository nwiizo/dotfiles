# Codex Entry Points

This directory exposes the managed Codex agents. Edit their source files in
`.agents/codex/`, not copies under the home directory.

| Managed source | Installed location |
|---|---|
| `.agents/codex/agents/` | `.codex/agents/` and individual links under `~/.codex/agents/` |
| `.agents/codex/AGENTS.md` | `~/.codex/AGENTS.md` |
| `.agents/skills/` | Shared skills installed by `scripts/link.sh` |

Keep repository guidance in the root `AGENTS.md`. See the
[shared configuration guide](../.agents/README.md) for skill locations and the
[official custom-agent documentation](https://learn.chatgpt.com/docs/agent-configuration/subagents)
for the supported agent fields. Claude and Codex definitions of the same role
should preserve the same responsibilities and read-only boundaries.

## Local settings and state

`~/.codex/config.toml` and named profile files stay local. Model, effort,
permissions, trust, plugins, and account-specific settings should be inspected
when that setting is part of the task; this README does not duplicate their
current values. Edit shared instructions in `.agents/codex/AGENTS.md` and shell
abbreviations in `fish/config.fish`.

Instruction maintenance does not require deleting sessions, changing credentials,
or cleaning plugin caches. Keep those files under the client's control. Diagnose
a missing rollout separately from a configuration parse failure.

## Apply and verify

From the repository root, after changing managed instructions:

```sh
rtk proxy ./scripts/audit-agent-config.sh
rtk git diff --check
```

Run `rtk proxy ./scripts/link.sh` when adding, retiring, or moving an installed
skill or agent. Editing an already linked file does not need relinking.
The audit checks managed assets, home links, TOML/YAML structure, and paired
roles; it does not prove that a role follows its instructions in every task.

For changes to local Codex settings, check the installed CLI's help and run
its native diagnostic:

```sh
rtk proxy codex --version
rtk proxy codex doctor --help
rtk proxy codex --strict-config doctor --summary
```

Keep diagnostic output containing local state out of tracked documents. Start a
new session to check changed startup instructions. Test behavioral changes with
a representative task; do not infer success from parsing alone.
