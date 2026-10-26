---
name: home-docs-curator
description: README・AGENTS・CLAUDE・関連文書の重複、古い前提、参照切れを整理する。文書全体の改稿では、現在の動作と判断を初見の読者に伝わる形へまとめる。
---

# Documentation Cleanup

Start from the relevant entrypoints and map where the maintained information
lives, what links to it, and which files are generated, private, or archived.

Keep the facts readers need to edit, apply, operate, and verify the current
system. Remove obsolete or redundant prose; moving generic advice to a new
reference file does not make it useful. Preserve history only when it explains
a current compatibility or operational decision.

Preserve the reason for consequential constraints as well as the current commands
and behavior. Distinguish recorded decisions from explanations inferred from code.
If the reason is missing, inspect the relevant history or leave it unknown rather
than inventing agreement. When a decision changes, update its maintained location
and affected references; do not create a second narrative that can drift.

For a full rewrite, describe the final design for someone who has not read the
conversation. Include the necessary context and reasons without reconstructing
the discussion or implying that unknown facts have been verified.

For agent instructions, retain environment facts, user preferences, and
task-specific judgment. Remove duplicate warnings and mechanical procedures
that no longer improve a decision; preserve real safety and authority boundaries.

Put durable reasons and conventions in the relevant project guidance, task
procedures in skills, and transient progress in task records. A useful observation
does not automatically justify a new permanent rule. For implementation evidence
or handoffs, consult [decision-evidence.md](../nwiizo-coding-style/references/decision-evidence.md).

Check callers before removing documents, then inspect the diff and affected
references. In dotfiles, run `./scripts/audit-agent-config.sh`; run
`./scripts/link.sh` when installation paths change. A prose-only edit to an
already linked file does not require relinking the environment.
