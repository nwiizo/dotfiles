---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/tsconfig.json"
---

# TypeScript Rules

- No `any` type in production code
- `strict: true` in tsconfig.json
- Package manager: `pnpm` > `npm` > `yarn`
- Quality: `npx prettier --write . && npx eslint . --fix && npx tsc --noEmit`
