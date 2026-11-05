# Herdr Operation Contracts

Checked against the installed Herdr 0.9.5 CLI, its bundled skill, and the
[official automation reference](https://herdr.dev/tui/docs/agent-automation/).
Recheck installed help when changing versions; website examples may target a
newer build.

## Establish the Target and Assignment

Before coordination, identify the session or machine, repository/cwd, intended
agent, permitted actions, and ownership supplied by the caller. A delegated task
needs its inputs, owned files, dependencies, and verification. Preserve the
caller's permission and model choices. Do not create a workforce simply because
Herdr is available.

For live CLI control, check `HERDR_ENV=1` and use the caller's context or observed
identifiers. If selecting a remote machine, keep the same selector throughout
discovery and later operations. Local installation and configuration do not
require entering another user's live pane.

## Choose the Operation

| Need | Interface |
|---|---|
| Shell, build, test, or server process | `herdr pane` |
| A recognized coding agent | `herdr agent` |
| Human attention and editor context | Signalbox or an explicit terminal attach |

Allocate an available shell pane before starting an agent. Preserve cwd and
the user's focus; obtain new IDs from the response. Re-resolve the target after
moving a pane. A Herdr name labels a live agent; it does not select a Claude or
Codex persona. Inspect the chosen client's help before passing role arguments.

## Submission and Completion

Before submitting, inspect the target and confirm that it can accept input.
An existing turn may satisfy a lifecycle wait, so do not equate that wait with
completion of a newly queued assignment. Use bounded waits that leave room for
progress updates.

On timeout, `agent_prompt_stalled`, or uncertain transport delivery, read current
state and recent output before retrying. Wait again for work already running;
do not repeat the prompt automatically. If blocked, inspect the actual dialog
and resolve only actions covered by existing authority. Return an unresolved
decision to the caller instead of using raw pane input to bypass it.

For apparent completion, inspect the response and assigned artifacts, review
owned diffs, and check the requested verification. An `idle`, `done`, or
`unknown` label is insufficient evidence. Report partial work and missing checks.

[Agent detection](https://herdr.dev/tui/docs/agents/#blocked-state) can miss an
unfamiliar setup or approval screen. Investigate unexpected idle states with
the installed `agent explain` and `agent read` commands before sending input.

## Persistence and Signalbox

[Detach preserves live processes; server restart does not](https://herdr.dev/tui/docs/session-state/).
Do not stop a shared server or close someone else's pane as routine cleanup.
Use an isolated test namespace for lifecycle experiments and clean up only
resources created by that experiment.

[Signalbox](https://github.com/nwiizo/signalbox.nvim) presents Herdr state and
temporary output previews; it does not replace the runtime. Use its explicit
attach/prompt/start actions. Rehome saved conversations through the provider's
resume picker after the original client is stopped, rather than claiming to
adopt a running process. Keep previews and transcripts out of Git.
