---
name: home-docs-curator
description: README・AGENTS・CLAUDEと関連文書を、現在の動作・編集先・操作・検証が初見で分かるよう整理する。
---

# Describe the Maintained System

Map entrypoints, maintained sources, generated files, private records, and links.
Keep the commands and environment facts needed to edit, apply, operate, and verify.

Rewrite full documents for a reader who has not seen the conversation.
Preserve consequential decisions and their recorded reasons; inspect history or
leave a reason unknown instead of inferring agreement from code.
Merge duplicate explanations with their existing owner and remove obsolete content.

For agent assets, retain useful local facts and task-specific judgment.
Generic tutorials and superseded procedures do not need a new reference file.
Check callers before removing a document and update affected references.

Inspect the final diff and links. In dotfiles, run
`rtk proxy ./scripts/audit-agent-config.sh`; relink only changed installation
paths. Distinguish static checks from actual client behavior.
