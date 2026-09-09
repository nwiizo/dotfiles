# Agent Configuration

This directory contains the reusable configuration managed by dotfiles.
Edit these sources; `scripts/link.sh` installs links into the client homes.

## Installation Map

| Source | Installed path |
|---|---|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `RTK.md` | `~/.claude/RTK.md`, `~/.codex/RTK.md` |
| `claudeignore` | `~/.claude/.claudeignore` |
| `agents/`, `rules/`, `docs/` | Corresponding directories under `~/.claude/` |
| `skills/<name>/` | `~/.claude/skills/<name>`, `~/.agents/skills/<name>` |
| `codex/AGENTS.md` | `~/.codex/AGENTS.md` |
| `codex/agents/*.toml` | `~/.codex/agents/*.toml` |

Project `.claude/{agents,rules,skills}` and `.codex/agents` also link here.
Skills are installed individually so external skills such as `nippo` and
the private blog bundle can coexist. Do not copy or remove their sources as
part of dotfiles maintenance.

## Instruction Ownership

| Information | Maintained in |
|---|---|
| Repository layout, apply commands, checks | Root `AGENTS.md`; root `CLAUDE.md` imports it |
| Codex user preferences | `codex/AGENTS.md` |
| Claude user preferences | `rules/coding.md`, `rules/security.md`, `rules/github-comments.md` |
| Path-specific preferences | `rules/*.md` with `paths` |
| Task-specific judgment and procedures | `skills/<name>/SKILL.md` |
| Specialized reviewer or planner role | Same-named files in `agents/` and `codex/agents/` |
| Deterministic enforcement | Existing hooks, config, or validation scripts |

Keep information that changes the model's decisions. Remove redundant tutorials,
fixed ceremonies, and obsolete workarounds rather than moving them into new
references. Preserve environment facts, explicit user preferences, and safety
boundaries. Details for maintenance are in `rules/authoring.md`.

Codex global preferences are self-contained because Codex does not load Claude's
rules or expand `@path` imports. Claude's global entrypoint points to its loaded
rules; the root `CLAUDE.md` imports `AGENTS.md` without repeating project guidance.
Keep overlapping user preferences aligned across the two clients.

The entrypoints follow [GPT-6 Astra's prompting guidance](https://developers.openai.com/api/docs/guides/latest-model#prompting-best-practices),
reviewed on 2026-09-08: finish authorized work, resolve conflicting skill guidance,
use concise prose, define delegation explicitly, and scale verification to the
change. Parallel agents remain opt-in for this environment. Repository-specific
checks and safety boundaries remain in place. This is an instruction cleanup,
not a measured claim of better model performance. See also
[Codex instruction discovery](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
and [Claude instruction loading](https://code.claude.com/docs/en/memory).

## Skills by Purpose

| Skill | Use |
|---|---|
| `add-config` | Source paths, application, and validation for dotfiles configuration |
| `add-package` | Homebrew package installation and repository tracking |
| `nwiizo-coding-style` | Minimal implementation modes, review/audit, debt/gain/help, and Rust similarity/coupling diagnostics |
| `home-karpathy-guidelines` | Preflight for material uncertainty or minimal implementation |
| `home-brainstorming` | Design exploration and requested design interviews |
| `home-data-shape-contract` | Persisted data and public-interface compatibility decisions |
| `home-test-driven-development` | Meaningful red/green behavior checks |
| `home-systematic-debugging` | Evidence-driven diagnosis when the cause is unknown |
| `home-verification-before-completion` | Evidence supporting completion claims |
| `home-self-review` | Independent review through the opposite AI CLI |
| `home-fix-review-comments` | Evaluate and apply review findings |
| `home-docs-curator` | Documentation and instruction cleanup |
| `home-history-distill` | Reusable guidance from bounded local history through `nippo` |
| `home-empirical-prompt-tuning` | Behavioral comparison of instructions |
| `home-validate-on-oss` | Explicitly requested validation on real projects |
| `home-rust-mentor` | Beginner-oriented Rust explanations |
| `home-marp-slide-editing` | Marp layout and rendered-output checks |
| `home-translation-quality` | Technical translation conventions and consistency |
| `home-incident-runbook-templates` | Service-specific response procedures |
| `home-postmortem-writing` | Evidence-based incident reviews |
| `home-aws-finops-investigation` | Local AWS investigation notes |
| `home-gcp-finops-investigation` | Local GCP investigation notes |

Choose personas by their descriptions; do not automatically run a fixed reviewer
set. `home-self-review` selects the other AI product; a persona name alone does not.

## Validation and Local State

Run `./scripts/audit-agent-config.sh` after edits. It checks links, skill and agent
metadata, same-named persona pairs, manual-only invocation parity, read-only
permissions, stale tooling references, and generated state. Ruby/Psych, yq, and
jq are the existing validators. It also scans secrets when git-secrets is installed.

Preserve client-specific metadata: Claude extensions in skill frontmatter and
Codex UI/invocation policy in `agents/openai.yaml`. Read-only personas pair
Claude `permissionMode: plan` with Codex `sandbox_mode = "read-only"`.
The memory editor and report writer retain the access their tasks need.

Static checks do not establish model performance. Use representative behavioral
evaluation when a change warrants it, and report its actual scope.

Keep sessions, history, caches, credentials, machine-specific settings, plugin
downloads, and runtime state outside this tree.
