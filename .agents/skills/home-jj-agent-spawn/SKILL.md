---
name: home-jj-agent-spawn
description: Spawn a parallel coding-agent session in its own jj workspace. Uses `jj_agent` if the nwiizo/jujutsu.fish plugin is installed, otherwise falls back to raw `jj workspace add`. Use when starting a second (or Nth) agent on a different task without disturbing the current working copy. Invoke manually; creates a workspace directory on disk.
disable-model-invocation: true
---

# jj Agent Spawn

Create a new jj workspace (the equivalent of `git worktree add`) and open it ready for an agent to start work.

The value of this workflow is isolation plus reversibility: each agent gets its own `@`, while all operations still land in the shared jj operation log.

## When to use

- User wants to run two or more agents on different tasks in parallel.
- User wants to try an alternative approach without contaminating the main working copy.
- User wants the agent's output isolated in its own `@` for later review.

## Prerequisites

- `.jj/` exists in the repo root.
- `$TMUX` is set if `--tmux` mode is desired.
- `$EDITOR` is set (or an explicit editor is provided).

## Rules

- Pick the base revision deliberately. Use `trunk()` for an independent task; use `@` only when the spawned agent should build on the current change.
- Do not spawn from a messy current `@` by accident. If the current workspace contains unrelated edits, finish them with the commit cycle, split them, or choose `trunk()` as the base.
- Each workspace has an independent `@`, but the operation log is shared across the repo. A rebase, squash, abandon, or undo in one workspace is visible from the others.
- In colocated repositories, use jj for mutating operations inside spawned workspaces. Read-only Git inspection is fine; `git commit`, `git rebase`, and branch-moving Git tools make jj workspace state harder to reason about.
- Before push/PR closeout, verify whether the finished change is `@` or `@-`. If the agent ran the commit cycle and opened a fresh child, the preserved change is usually `@-`.
- Forgetting a workspace and deleting a directory are not the same as undoing its changes. Use `jj op log`, `jj undo`, or `jj op restore` when you need to reverse repository state.

## Steps

1. Pick a workspace name. Short, descriptive, kebab-case:
   - Good: `fix-auth`, `review-pr-42`, `try-approach-b`.
   - Bad: `agent1`, `tmp`, `wip`.

2. Pick the base revision:
   - Use `trunk()` for a clean, independent task.
   - Use `@` only if the new agent should build on the current workspace's change.
   - Use a specific change ID when the task should branch from a known in-flight change.

3. Spawn. Prefer the plugin wrapper if available:
   ```fish
   # Preferred: with nwiizo/jujutsu.fish installed
   jj_agent <name> -r 'trunk()'
   jj_agent <name> --tmux           # opens a new tmux window
   jj_agent <name> -e 'claude'      # override editor

   # Fallback: plain jj
   jj workspace add --name <name> -r 'trunk()' ../<name>
   cd ../<name>
   $EDITOR .
   ```

4. Confirm the workspace registered:
   ```fish
   jj workspace list          # or `jj_agent_list` if the plugin is installed
   jj st
   ```
   The new workspace should appear with an empty `@`.

## Lifecycle follow-ups

Plugin-available shortcuts (otherwise run the underlying jj commands):

- Compare two agents' output: `jj_agent_diff <A> <B>` (or `jj diff --from <A>@ --to <B>@`).
- Close out a workspace: inspect `jj st` and `jj log -r '@-::@'`, push the intended change (`@` or `@-` depending on whether a commit cycle was run), then `jj_agent_done <name> --push-pr --forget` or summarize + push + `jj workspace forget <name>`.
- Cleanup of empty abandoned workspaces: `jj_agent_prune --dry-run` then `jj_agent_prune`.

## Notes for the invoking agent

- The spawned session is an **independent** jj workspace. Operations there record into the **shared** op log, so the main agent can see what the spawned agent did via `jj op log` from any workspace.
- Do not invoke this skill programmatically just to create a workspace — the skill exists so the user explicitly chooses the name, base, and mode.
- If multiple agents touch related code, compare their resulting changes before pushing. Isolation prevents working-copy contamination; it does not resolve semantic conflicts for you.
