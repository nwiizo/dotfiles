---
name: home-jj-commit-cycle
description: In any jj (Jujutsu) repository, complete the "commit" pattern — describe the current working copy with a message, then open a fresh change for the next unit of work. Use when a coherent edit is finished and should be preserved before moving on. Teach the user how `@`, `@-`, `jj describe`, `jj new`, and `jj split` replace Git's staging-and-commit model, and show the exact jj commands executed. Invoke manually; mutates state.
disable-model-invocation: true
---

# jj Commit Cycle

The jj equivalent of finishing one coherent unit of work. It is closest to `git add -A && git commit -m "<msg>"`, but the mental model is different: jj has no staging area, and the working copy is already a commit (`@`). The cycle is therefore: describe the current `@`, inspect it, then open a fresh child change for the next unit of work.

`jj commit -m "<msg>"` does `jj describe` and `jj new` in one command when no paths or `--interactive` are given. This skill keeps the two steps separate so you can inspect with `jj st` / `jj diff` before finalizing.

## Mental model to teach

Explain the state transition, not only the command sequence:

- `@` is already a mutable commit containing the working-copy changes. There is no Git-style staging area to populate with `add`.
- `jj describe` gives the current `@` a description; it does not freeze or leave that change.
- `jj new` creates a fresh child and moves the workspace's `@` to it. The preserved change that was `@` is then usually `@-`.
- Bookmarks do not automatically follow `@`. Finishing a change and publishing a bookmark are separate operations.
- When unrelated files are mixed in `@`, use `jj split` to create an atomic change instead of pretending to stage selected files.

Use a compact before/after sketch when it helps:

```text
before jj new:  @  = described finished change
after jj new:   @- = finished change
                @  = fresh child for the next task
```

## When to use

You (or the user) just finished an atomic edit in a jj working copy and want to preserve it before starting the next change.

## Prerequisites

- `.jj/` exists in the repo root (jj-native or colocated).
- There is one coherent current change to preserve. Usually `jj st` shows file changes, but an already-described `@` with no file changes can also be finalized if that is intentional.
- In a colocated repo, prefer read-only `git` commands while using this cycle. Mutating Git commands are allowed by jj, but they make `@`, bookmarks, Git HEAD, and branch positions harder to reason about.

## Rules

- Use jj to create and rewrite changes. Use Git mainly for inspection in colocated repositories unless you intentionally switch workflows.
- Treat `jj new` as the boundary between units of work. Before `jj new`, the just-described change is `@`; after `jj new`, it is usually `@-`.
- Before pushing or opening a PR, verify which revision you mean to publish. Do not assume `@` still points at the preserved change.
- Do not treat `.jj/` deletion as a universal undo. Use `jj undo` / `jj op restore` for jj operations, and inspect Git branch state before abandoning colocation.

## Steps

1. Survey what will be preserved:
   ```fish
   jj st
   jj diff --stat
   ```
   Confirm that the diff is the unit you want to preserve. If unrelated edits are mixed in, split or squash before describing.

   To select whole files into a separate change without an interactive editor:

   ```fish
   jj split -m "<type>(<scope>): <subject>" path/to/file path/to/directory
   ```

   Explain that the selected part becomes one commit and the remaining edits stay in a child commit. In this case, `jj split` already creates the boundary that `jj new` would otherwise provide; do not add another `jj new` mechanically.

2. Describe the current change. Follow the repo's commit convention (typically `<type>(<scope>): <subject>`):
   ```fish
   jj describe -m "<type>(<scope>): <subject>"
   ```

3. Inspect once more if the change was non-trivial:
   ```fish
   jj st
   jj diff --stat
   ```

4. Open a new child change so the just-described change is finalized and future edits land on a fresh `@`:
   ```fish
   jj new
   ```

5. Verify. After `jj new`, the preserved change should be `@-`, and the new `@` should be empty or ready for the next task:
   ```fish
   jj st
   jj log -r '@-::@'
   ```

## Common mistakes

- **Skipping `jj new`**: any further edits get absorbed into the change you just "committed", silently polluting it.
- **Pushing `@` after `jj new`**: after the cycle, `@` is the fresh child change. The change you just preserved is usually `@-`.
- **Running mutating Git commands in a colocated repo**: jj can interoperate with Git, but `git commit`, `git rebase`, or Git tooling that moves branches can make the relationship between `@`, bookmarks, Git HEAD, and branch positions confusing. In this workflow, create changes with jj and use Git mainly for inspection unless you intentionally switch workflows.
- **Treating `.jj/` removal as a perfect undo**: colocated mode keeps Git data, but before abandoning jj, inspect Git branch positions and working-copy state. Do not assume deleting `.jj/` alone restores every workflow-level expectation.

## User-facing handoff

After the cycle, report:

- The exact jj commands executed, including wrappers such as `rtk` when they were actually used.
- The finished change ID and commit ID, its description, and whether it is now `@` or `@-`.
- The remaining state of `@`: empty, ready for the next task, or still containing explicitly preserved unrelated work.
- Whether any bookmark moved or anything was pushed. Say explicitly when neither happened.

Keep the explanation tied to the observed result. For example: “`jj split` selected this file into `@-`; the unrelated files remain in `@`.” Do not describe jj as having staged files.

## Related

- Multi-change cleanup: `jj squash --from <src> --into <dst>`, `jj split`.
- Recovery if the wrong change was described: `jj undo` (undoes the last operation; `jj op` has `restore`/`revert`, but there is no `jj op undo` subcommand).
- Pushing the preserved change after the cycle: `jj git push --change @-` (creates a `push-<change-id>` bookmark for the described change). If you have not run `jj new` yet, the target is still `@`.
- If the `nwiizo/jujutsu.fish` plugin is installed, `jj_push_pr` chains `jj git push --change ...` with `gh pr create`; confirm whether it targets `@` or `@-` in your current position.
