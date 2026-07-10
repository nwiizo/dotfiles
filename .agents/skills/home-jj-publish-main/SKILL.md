---
name: home-jj-publish-main
description: jj リポジトリで検証済みの変更を確定し、main bookmark を進め、origin/main へ push する。ユーザーが「コミットしてpush」「mainにマージして」と依頼したときに使用する。bookmark・working-copy commit・remote bookmark の違い、fast-forward の意味、実行した jj コマンドをユーザーへ説明する。
---

# home-jj-publish-main

Finish and publish a coherent jj change to `origin/main`.

## Preconditions

- The user explicitly asked to commit and push.
- The working copy contains one coherent change, or the finished target has already been isolated as a known revision such as `@-` by `jj new` or `jj split`.
- Required validation has passed or failures are reported clearly.

## Mental model to teach

Explain these distinctions briefly:

- `@` is the workspace's current mutable commit. `main` is a movable local bookmark; it is not the current checkout in the Git sense.
- `jj bookmark set main -r <target>` moves only the local bookmark. It does not contact the remote.
- `jj git push --bookmark main` publishes the local bookmark to its tracked remote bookmark, usually `main@origin`.
- If `<target>` is a direct descendant of `main`, moving `main` is a fast-forward. Do not claim that a merge commit was created.
- `@-` means “the parent of the current workspace commit,” not “the last good commit” universally. Resolve and verify the intended target before using it.
- A rewrite such as `jj metaedit` changes Git commit IDs for that revision and its descendants even when file contents stay unchanged. Report the final ID after all rewrites.

## Workflow

1. Inspect the working copy, target, and bookmark topology:

```bash
jj st
jj diff --stat
jj log -r 'main|main@origin|@-|@'
git ls-remote origin refs/heads/main
```

Identify the finished target explicitly. If it is already `@-` and `@` contains unrelated work, publish `@-`; do not describe or publish the mixed current `@`.

2. Verify identity on every unpublished revision:

```bash
jj config list --include-defaults | rg '^user\.'
jj log -r 'main@origin::<target>'
```

If the author is empty, copy the repo's Git identity into jj repo config and
run `jj metaedit --update-author -r <revision>`. Reinspect the log afterward because descendant commit IDs will change.

3. If the finished target is the current `@`, describe it:

```bash
jj describe -m '<type>(<scope>): <subject>'
```

4. If the finished target is still `@`, open a fresh child change:

```bash
jj new
```

Skip steps 3–4 when `jj split` or an earlier commit cycle already produced the finished target as `@-` and left unrelated work in `@`.

5. Move `main` to the verified target:

```bash
jj bookmark set main -r @-
```

Use an explicit change ID instead of `@-` when the workspace topology is not obvious.

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

Confirm that the remote hash equals the final commit ID of `main`.

## Recoverable push blockers

- If jj reports `Non-tracking remote bookmark main@origin exists`, establish the relationship explicitly and retry:

  ```bash
  jj bookmark track main --remote=origin
  jj git push --bookmark main
  ```

- If jj rejects an unpublished ancestor because its author or committer is empty, inspect the entire unpublished range, repair only the affected revision, and retry:

  ```bash
  jj log -r 'main@origin::main'
  jj metaedit --update-author -r <revision>
  jj log -r 'main@origin::main'
  ```

  Explain that this is a metadata rewrite and therefore changes descendant Git commit IDs.

## Output

Report:

- The exact jj commands executed, in order. Include wrappers such as `rtk` if they were actually used.
- The final commit hash and push target.
- Whether `main` moved by fast-forward or a merge commit was genuinely created.
- The verified remote hash.
- The state of the current `@`, including unrelated work intentionally left unpushed.

Pair commands with one-sentence explanations so the user can reuse the workflow. Do not merely dump a transcript, and do not use Git staging terminology for jj operations.
