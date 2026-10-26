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
Skills are installed individually so external skills such as `nippo`, `suiko`, and
the private blog bundle can coexist. Do not copy or remove their sources as
part of dotfiles maintenance.

## Instruction Ownership

| Information | Maintained in |
|---|---|
| Repository layout, apply commands, checks | Root `AGENTS.md`; root `CLAUDE.md` is a symlink to it |
| Directory-specific project guidance | Nested `AGENTS.md`; a sibling `CLAUDE.md` symlink shares it with Claude |
| Codex user preferences | `codex/AGENTS.md` |
| Claude user preferences | `rules/coding.md`, `rules/security.md`, `rules/github-comments.md` |
| Claude path-specific preferences | `rules/*.md` with `paths` |
| Task-specific judgment and procedures | `skills/<name>/SKILL.md` |
| Specialized reviewer or planner role | Same-named files in `agents/` and `codex/agents/` |
| Deterministic enforcement | Existing hooks, config, or validation scripts |

Keep information that changes the model's decisions. Remove redundant tutorials,
fixed ceremonies, and obsolete workarounds rather than moving them into new
references. Preserve environment facts, explicit user preferences, and safety
boundaries. Details for maintenance are in `rules/authoring.md`.

Codex global preferences are self-contained because Codex does not load Claude's
rules or expand `@path` imports. Claude's global entrypoint points to its loaded
rules; the root `CLAUDE.md` is a symlink to `AGENTS.md`.
Keep overlapping user preferences aligned across the two clients.

## Shared Project Instructions

Reviewed against official documentation on **2026-10-10**; installed clients
were Claude Code **2.1.294** and Codex CLI **0.162.1**.

Keep `AGENTS.md` as the file to edit and `CLAUDE.md` as a tracked relative symlink.
This macOS repository needs no separate Claude project content. Claude supports
this arrangement, including deduplication when both filenames are discovered.
Its native `AGENTS.md` loading, available since 2.1.277, depends on project
instruction settings and other instruction files; retaining the link avoids
depending on that fallback. See [Claude's sharing guidance](https://code.claude.com/docs/en/memory#share-one-file-with-other-coding-tools).

Codex discovers instructions from the project root down to its launch directory,
choosing one file per directory: `AGENTS.override.md`, then `AGENTS.md`, then a
configured fallback. A root-started task should explicitly read nested guidance
before changing that area; keep conditional links in the root guide. Shared
files use ordinary Markdown links, since Codex does not expand Claude imports.
See [Codex instruction discovery](https://learn.chatgpt.com/docs/agent-configuration/agents-md).

Keep entrypoints focused on commands, verification, environment-specific pitfalls,
and decisions the agent cannot infer reliably. Put detailed explanations in the
area README and occasional workflows in skills. Add guidance for repeated
mistakes and remove obsolete rules instead of accumulating incident history.
These are maintenance choices informed by
[Codex best practices](https://learn.chatgpt.com/guides/best-practices#make-guidance-reusable-with-agentsmd)
and [Claude best practices](https://code.claude.com/docs/en/best-practices#write-an-effective-claudemd).

After changing instruction loading, run the repository audit, then use `/context`
in a fresh Claude session to inspect Memory files. Start a fresh Codex session
in the intended directory and ask it to list the active instruction sources;
check the listed files against the repository. File and link checks establish
the layout, not actual client loading or improved model behavior.

## Skills by Purpose

| Skill | Use |
|---|---|
| `add-config` | Source paths, application, and validation for dotfiles configuration |
| `add-package` | Homebrew package installation and repository tracking |
| `nwiizo-coding-style` | Minimal implementation modes, action-first progress reporting, review/audit, debt/gain/help, and Rust similarity/coupling diagnostics |
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
| `home-ci-efficiency` | CI feedback time, total execution, and reliability measured separately |
| `home-terraform-change-review` | Terraform plan changes tied to access, availability, data migration, and recovery |
| `home-observability-design` | Question-driven signals, SLI/SLOs, missing telemetry, alert actions, and measurement costs |
| `home-validate-on-oss` | Explicitly requested validation on real projects |
| [`learn-rust` (external plugin)](https://github.com/nwiizo/rust-learning-lab) | Rust syntax, rationale, practice, and debugging; install Rust Learning Lab through each client's plugin marketplace |
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
