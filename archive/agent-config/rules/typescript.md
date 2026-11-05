---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/tsconfig.json"
---

# TypeScript Rules

- No `any` type in production code
- Enable `strict` for new configurations and preserve existing strictness. A local edit does not require migrating an existing project's compiler settings.
- Use the existing package manager and lockfile. For a new project, prefer `pnpm`, then `npm`, then `yarn`.
- Run the repository's configured formatting, lint, typecheck, and test scripts for affected packages and behavior, preserving required CI checks. Broaden or repeat checks only for changes, failures, or unresolved concerns. Review-only checks must not use `--write` or `--fix`; avoid whole-repository autofixes and implicit downloads through bare `npx`.
