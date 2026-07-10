# Agent and Skill Integration Design

## Goal

Keep `~/.agents` portable and small while managing Claude Code and Codex
subagents from the dotfiles repository. Incorporate useful patterns from
official documentation and popular repositories without importing large,
overlapping, or weakly licensed prompt collections.

## Scope

- Align Claude Code and Codex around the same eleven agent roles.
- Remove agents whose responsibilities overlap existing agents or skills.
- Strengthen reviewer prompts with evidence, impact, confidence, and explicit
  no-finding behavior.
- Add focused GitHub review/CI and React/Next.js skills.
- Record upstream provenance and provide read-only update checks.
- Extend the existing audit so drift is detected before publishing changes.

This work does not install runtime state, commit credentials, change local
approval policy, or automatically overwrite vendored content from upstream.

## Agent Architecture

Claude definitions remain in `.agents/agents/*.md`; Codex definitions remain
in `.agents/codex/agents/*.toml`. Both products expose the same role names, but
each keeps its native configuration format.

The final role set is:

1. `home-cli-ux-reviewer`
2. `home-code-reviewer`
3. `home-constructive-reviewer`
4. `home-design-reviewer`
5. `home-dotfiles-environment-auditor`
6. `home-incident-responder`
7. `home-jj-reviewer`
8. `home-planner`
9. `home-rust-reviewer`
10. `home-simplify-reviewer`
11. `home-test-reviewer`

Remove `home-codex-reviewer` because a vague second opinion duplicates the
code reviewer without adding a stable review dimension. Remove
`home-memory-optimizer` because repository documentation curation and context
extraction belong to `home-docs-curator`.

All review, planning, audit, and incident-triage agents are read-only. Claude
uses `permissionMode: plan`; Codex uses `sandbox_mode = "read-only"`. Claude
agents inherit the active model instead of pinning a model alias. Agent
descriptions state when delegation is appropriate, and prompts explicitly
avoid speculative or manufactured findings.

## Review Contract

Review agents stay within their named dimension. Findings identify a concrete
location when available, distinguish evidence from inference, explain impact,
and provide an actionable recommendation. Correctness-oriented reviewers
filter low-confidence observations; a clean review reports no findings rather
than filling a template.

`home-test-reviewer` evaluates behavioral coverage instead of percentage
targets. It prioritizes critical paths, boundaries, negative cases,
concurrency, error handling, integration contracts, determinism, and tests
that would catch real regressions.

## Skill Integration

- Extend `home-fix-review-comments` with an optional GitHub PR mode that reads
  review comments before applying only technically valid feedback.
- Add `home-gh-fix-ci` for GitHub Actions failure inspection, local
  reproduction, minimal correction, and fresh verification. It never pushes
  or reruns external workflows without explicit authorization.
- Add `home-react-next-performance`, a concise local workflow informed by
  Vercel's React guidance. It prioritizes waterfalls, bundle size, server/client
  boundaries, rerenders, and measured evidence without copying the upstream
  repository wholesale.
- Update `home-self-review` to use the stable dimensions `code`, `simplify`,
  and `test`, adding language or domain reviewers only when relevant.

New or substantially revised skills receive `agents/openai.yaml` metadata and
are validated with the local skill validator.

## Upstream Tracking

`.agents/upstreams.lock.json` records the repository, path, pinned revision,
license status, and whether a source was adapted or used only as a reference.
A read-only checker queries GitHub and reports drift. Updates remain manual so
local prompts are never silently overwritten.

## Validation

`scripts/audit-agent-config.sh` will additionally verify:

- matching Claude and Codex agent names;
- unique names and filename/name agreement;
- required Claude frontmatter and Codex TOML fields;
- read-only permission settings;
- absence of generated/cache files and broken links;
- valid skill frontmatter and OpenAI metadata;
- valid upstream lock structure.

Representative high-use prompts are forward-tested against normal, edge, and
hold-out scenarios. Final verification includes shell syntax checks, TOML/JSON
parsing, skill validation, link application, the agent audit, and a scoped diff
review.

## Failure Handling

Network failures in upstream checks are reported without changing files.
Missing GitHub authentication produces setup guidance rather than partial
results. External checks without accessible logs are identified as such.
Existing unrelated working-copy changes are preserved throughout the work.
