# Codex Entry Points

Codex reads repository skills from `.agents/skills` and project custom agents
from `.codex/agents`.

This repository keeps reusable Codex agent definitions in `.agents/codex/` and
exposes them here as symlinks:

| Path | Source |
|---|---|
| `agents/` | `../.agents/codex/agents/` |

Use `.agents/codex/agents/` for edits. `scripts/link.sh` also links these
agents into `~/.codex/agents` for user-level reuse. Keep durable repository
guidance in `AGENTS.md`; keep repeatable workflows in `.agents/skills/`.

## Configuration maintenance

The personal `~/.codex/config.toml` stays outside this repository because it
also contains local project trust, plugin state, and hook trust. Update that
file directly; edit the linked global instructions in
`.agents/codex/AGENTS.md` and shell abbreviations in `fish/config.fish`.

Reviewed against Codex CLI **0.153.4** on **2026-09-06**. The main settings are
GPT-6 Astra with `xhigh` reasoning in both normal and Plan mode, Standard service,
live web search, and workspace-write with automatic approval review. The
existing `cx` permission-bypass abbreviation is an intentional local exception.

- `service_tier = "default"` keeps Standard processing as the default.
  [Astra Fast mode](https://learn.chatgpt.com/docs/agent-configuration/speed)
  consumes ChatGPT credits at 2.5x the Standard rate. Use `/fast on` when
  latency matters, then `/fast off` afterward: the toggle persists its selection.
- Keep the current model and `xhigh` for sustained reasoning work. Use `/model`
  to lower effort for small, well-scoped tasks instead of changing the default
  model or claiming that one effort level is best for every task.
- `project_doc_fallback_filenames = ["CLAUDE.md"]` allows repositories without
  `AGENTS.md` to supply their existing instructions. It does not merge both
  files from the same directory or implement Claude's `@path` imports.
- Custom agents are discovered from `~/.codex/agents/*.toml`. Keep their names,
  descriptions, and settings there instead of duplicating role entries in
  the main config. The repository audit checks every managed agent and its
  home link, including the matching Claude role and read-only permissions.
- The TUI status line shows model/reasoning, remaining context, five-hour and
  weekly allowance when available, directory, and Git branch. `/status` and
  `/usage` provide more detail. Notifications keep the existing Ghostty OSC 9 setup.
- Named profiles use `~/.codex/<name>.config.toml`. The existing
  `translation-longrun.config.toml` remains available through
  `codex --profile translation-longrun` and retains its explicit Fast override.
  Inline `[profiles.<name>]` tables
  are no longer the supported profile selection mechanism.
- Keep model context-window and automatic-compaction limits unset unless a
  measured task needs an override. A copied large number is not evidence
  that a model or client will use that window effectively.
- Keep authentication storage, existing command approvals, and project trust
  separate from tuning. A config refresh should not silently migrate login
  credentials, remove history, or enable additional external services.
- `history.max_bytes = 104857600` caps prompt-recall history at 100 MiB.
  It does not cap session transcripts, SQLite databases, or downloaded plugins.
  Cache cleanup must preserve resumable sessions and installed plugin files.
- Global instructions prohibit ad hoc Python helpers, route recurring custom
  helpers to a maintained Rust CLI, and keep already-authorized work moving
  without repeated confirmation.

### Community guidance considered

There is no single demonstrated best configuration across these sources.
They describe different priorities and are not comparative benchmarks.

| Source | Useful guidance | Decision for this setup |
|---|---|---|
| [Trail of Bits Codex Config](https://github.com/trailofbits/codex-config) | Explicit reasoning settings, automatic approval review, project guidance, and a visible status line | Align Plan effort, add the guidance fallback and status line; retain the already-current Astra model and local permission choices |
| [Jason Liu: Codex-maxxing](https://jxnl.github.io/blog/writing/2026/05/10/codex-maxxing/) | Durable work threads, reviewable files for decisions, and verifiable goals | Continue using project docs and reusable skills; do not enable every memory or background feature globally |
| [r/codex: reducing usage](https://www.reddit.com/r/codex/comments/1tznqct/how_can_i_decrease_codex_limits_usage/) | Users suggest adjusting effort to task difficulty and reducing repeated context | Preserve the quality-oriented default; use `/model` or a per-run override for lighter work, and retain RTK |
| [r/codex: context-window override report](https://www.reddit.com/r/codex/comments/1w2886c/codex_not_giving_the_user_set_context_window_and/) | One Windows user reports that a large context override stopped taking effect | Treat as a user report, not a confirmed cross-platform bug or a reason to copy the override |

The Trail of Bits template also uses organization-specific sandbox and
credential-storage choices. Those are not prerequisites for adopting its
workflow ideas. Its cached-search setting is not equivalent to the model's
prompt cache; this setup keeps live search for research tasks.

### Verification after changes

```sh
rtk proxy codex --version
rtk proxy codex --strict-config doctor --summary
rtk proxy ./scripts/audit-agent-config.sh
rtk proxy codex --profile translation-longrun mcp list
rtk git diff --check
```

`doctor` also checks thread storage. Warnings about missing old rollout files
are separate from a config parse failure; inspect them without deleting or
rewriting the session databases. Start a new Codex session after editing the
global defaults. New Fish shells load the updated abbreviations.

For Fish changes, also run `fish -n fish/config.fish fish/conf.d/*.fish`.
The repository-wide `scripts/audit-agent-config.sh` uses the existing
Ruby/Psych YAML validator and `yq`/`jq` for Codex agent TOML. It can run under
the no-Python policy. After a skill or agent is retired, `scripts/link.sh`
removes dangling home links that point into the managed source directories.
See [the skill catalog](../.agents/README.md#skills-by-purpose)
for replacement names.

Official references: [configuration](https://learn.chatgpt.com/docs/config-file/config-reference),
[best practices](https://learn.chatgpt.com/guides/best-practices),
[speed](https://learn.chatgpt.com/docs/agent-configuration/speed),
[TUI commands](https://learn.chatgpt.com/docs/developer-commands),
[profiles](https://learn.chatgpt.com/docs/config-file/config-advanced#profiles),
[project instructions](https://learn.chatgpt.com/docs/agent-configuration/agents-md),
[custom agents](https://learn.chatgpt.com/docs/agent-configuration/subagents),
[0.153.4 release](https://github.com/openai/codex/releases/tag/rust-v0.153.4).
