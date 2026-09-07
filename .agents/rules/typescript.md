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
- Run the repository's configured formatting, lint, typecheck, and test scripts. Review-only checks must not use `--write` or `--fix`; avoid whole-repository autofixes and implicit downloads through bare `npx`.
