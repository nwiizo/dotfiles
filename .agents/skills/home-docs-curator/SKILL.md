---
name: home-docs-curator
description: README、AGENTS、CLAUDE、ツール別READMEを俯瞰し、重複・古い前提・読みにくい構成・不要ファイルを整理する。ドキュメント整備やリポジトリを読みやすくしたいときに使用。
---

# home-docs-curator

Use this skill for documentation cleanup across a repository.

## Workflow

1. Read root entry points first:
   - `README.md`
   - `AGENTS.md`
   - `CLAUDE.md`
   - tool-specific README files

2. Build a map:
   - setup and apply commands
   - source-of-truth files
   - generated or linked targets
   - archive/reference-only paths

3. Remove or merge docs only when they are redundant:
   - duplicate instructions with no additional context
   - stale references to removed tooling
   - generated state or local-only notes

4. Keep docs task-oriented:
   - where to edit
   - how to apply
   - how to validate
   - what not to track

5. Validate claims against the repo:

```bash
rg -n "stale term|removed tool|old path"
./scripts/link.sh
```

## Don't

- Do not preserve historical explanations in active docs just because they are interesting.
- Do not move local secrets, sessions, caches, or logs into documentation.
- Do not create a second source of truth when a table can point to the existing file.
