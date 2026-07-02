---
name: home-jj-publish-main
description: jj リポジトリで検証後に現在の変更を describe し、main bookmark を進め、origin/main へ push する。ユーザーが「コミットしてpush」と依頼したときに使用。
---

# home-jj-publish-main

Finish and publish a coherent jj change to `origin/main`.

## Preconditions

- The user explicitly asked to commit and push.
- The working copy contains one coherent change.
- Required validation has passed or failures are reported clearly.

## Workflow

1. Inspect:

```bash
jj st
jj diff --stat
```

2. Verify identity:

```bash
jj config list --include-defaults | rg '^user\.'
```

If the author is empty, copy the repo's Git identity into jj repo config and
run `jj metaedit --update-author`.

3. Describe the current change:

```bash
jj describe -m '<type>(<scope>): <subject>'
```

4. Open a fresh child change:

```bash
jj new
```

5. Move `main` to the finished parent:

```bash
jj bookmark set main -r @-
```

6. Confirm:

```bash
jj st
jj bookmark list
```

7. Push:

```bash
jj git push --bookmark main
git ls-remote origin refs/heads/main
```

## Output

Report the commit hash, push target, and working-copy cleanliness.
