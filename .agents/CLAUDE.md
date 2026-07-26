# Claude Code Config

## Agent Routing

| Trigger | Agent |
|---------|-------|
| Scope unclear, multiple approaches, risk assessment | home-planner |
| PR review, code quality/security check | home-code-reviewer |
| Readability/consistency/maintainability review | home-simplify-reviewer |
| Rust code review | home-rust-reviewer |
| CLI UX review | home-cli-ux-reviewer |
| Design document review | home-design-reviewer |
| Review comment quality | home-constructive-reviewer |
| Final review, independent second opinion, parallel review trio | home-codex-reviewer |
| jj history / workspace review | home-jj-reviewer |
| dotfiles-wide environment audit | home-dotfiles-environment-auditor |
| CLAUDE.md restructuring, memory optimization | home-memory-optimizer |
| Production incident, outage triage, SRE practices | home-incident-responder |
| Daily report, work summary, or catch-up report through today | home-nippo-reporter |

## Workflow

- 実装や文書修正などの作業後、重要変更・不安の残る変更・リリース前など必要な場合は `home-code-reviewer`、`home-simplify-reviewer`、`home-codex-reviewer` の 3 agents で並行レビューする
- Rust、CLI、設計書、jj など対象が明確な場合は、対応する専門 reviewer agent を追加する
- レビュー指摘の本文を整える場合は `home-constructive-reviewer` を使う

## Rules

- [security](rules/security.md) — Universal NEVER/MUST constraints
- [coding](rules/coding.md) — Commit format, VCS discipline, universal rules
- Path-scoped: [content-editing](rules/content-editing.md) | [authoring](rules/authoring.md) | [rust](rules/rust.md) | [go](rules/go.md) | [typescript](rules/typescript.md) | [python](rules/python.md)

## Docs (on-demand)

### Languages
rust: [core](docs/rust-core.md) | [sqlx](docs/rust-sqlx.md) | [advanced](docs/rust-advanced.md)
[go](docs/go.md) | [typescript](docs/typescript.md) | [python](docs/python.md) | [bash](docs/bash.md)

### Operations
[git-workflow](docs/git-workflow.md) | [gcp-security](docs/gcp-security.md)

### Agent Tooling
[claude-code](docs/claude-code.md) | [codex](docs/codex.md)

@RTK.md
