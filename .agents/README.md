# Agent Configuration

This directory holds dotfiles-managed agent assets.
The root AGENTS.md remains the repository overview and lists apply/check commands.

## Installation

| Source | Installed path |
|---|---|
| CLAUDE.md | ~/.claude/CLAUDE.md |
| RTK.md | ~/.claude/RTK.md and ~/.codex/RTK.md |
| claudeignore | ~/.claude/.claudeignore |
| agents/ | ~/.claude/agents/ |
| skills/NAME | ~/.claude/skills/NAME and ~/.agents/skills/NAME |
| codex/AGENTS.md | ~/.codex/AGENTS.md |
| codex/agents/*.toml | ~/.codex/agents/*.toml |

Project .claude/agents and .claude/skills, plus .codex/agents, link here.
The former rules directory is preserved under
[`archive/agent-config/`](../archive/agent-config/README.md); its managed links
have been removed.
Historical investigation notes are not installed into client homes.
Machine-local tool permissions and client settings stay under client control.
External skills and the private blog bundle remain independently maintained.

Edit repository sources. Existing linked-file edits apply without relinking;
changed installation paths use `rtk proxy ./scripts/link.sh`.

## Skill Design

Each SKILL.md states its actual job, invocation conditions, result, and the
boundaries specific to that job. Keep non-obvious commands and domain knowledge.
Use supporting references when the task needs them; avoid loading all references
or prescribing a fixed reviewer roster.

Integration is appropriate when another skill can produce the same result from
the same input without losing an important distinction.
Different review questions can share general instructions while retaining their
own domain checks. Preserve names, supported metadata, and manual-only invocation
unless changing those interfaces is intentional.

General preferences belong to the client entrypoint; repository facts belong
to its overview. Actual permissions are controlled by client configuration,
not by prose. Do not turn a skill's recommendation into another approval round.

Write language and style guidance as the desired behavior, with its context and
a short positive example when needed. Specify Japanese prose separately from
technical terminology: ソースコード, テスト, バージョン, and API remain ordinary
choices in Japanese explanations. Scope wording preferences to the expression
and context the user identified. Keep explicit safety, permission, and
data-integrity boundaries intact when revising prohibitions.

Choose a skill by the requested result and the problem it resolves. Writing in
Japanese alone uses the client communication guidance; requested prose writing
or polishing uses the relevant writing workflow. Honor explicit skill requests.
When a workflow applies, complete its applicable required checks. Keep useful
reasoning, examples, and tradeoffs in substantive answers, with detail proportional
to the question. Review templates organize supported findings. Use scores when
requested and positive observations when they explain a useful implementation choice.

The implementation skill includes conditional preflight, completion-evidence,
and review-finding guidance. They share the implementation result rather than
requiring separate skill selection.
Local AWS and Google Cloud investigation notes use one provider-routed entrypoint.
The [Herdr skill](skills/herdr/SKILL.md) uses the installed CLI guide for the
default persistent workspace manager; [setup](../herdr/README.md) documents its
client integrations and selected plugins.
`home-herdr-operator` is the paired Claude Code/Codex operations role for scoped
Herdr setup, diagnosis, and explicitly authorized coordination. It inherits the
caller's execution policy and does not automatically start other agents.
Design, diagnosis, tests, CI measurement, releases, translation, and incident
documents retain distinct task entrypoints.

## Model Guidance

Reviewed 2026-11-05 for the configured gpt-6.1-sol workflow and shared Claude use.

The [GPT-6 prompting guide](https://developers.openai.com/api/docs/guides/latest-model#prompting-best-practices)
calls out initiative, sensitivity to conflicting skill instructions, writing
style, delegation, and proportional verification.
The [Codex workflow guide](https://learn.chatgpt.com/guides/best-practices)
emphasizes a goal, relevant context, constraints, and observable completion.
[Skill documentation](https://learn.chatgpt.com/docs/build-skills)
describes progressive disclosure.
[Claude guidance](https://code.claude.com/docs/en/best-practices#keep-claudemd-short)
recommends keeping recurring context focused on information the model cannot infer.

This setup applies those ideas to local workflows: concise task entrypoints,
conditional references, preserved user authorization, and checks tied to the
affected result. Model IDs and reasoning settings remain local client settings.
These design choices do not establish improved model performance.

## Validation

Run `rtk proxy ./scripts/audit-agent-config.sh`.
It checks installation links, metadata, paired personas, invocation-policy parity,
read-only role settings, generated state, and retired paths. It also rejects stale
managed skill/agent links and links into `archive/` in installed asset directories.
Keep client-specific metadata and reference assets needed by actual tasks.
Check affected local Markdown links and inspect the diff.

When changing the audit, run
`rtk proxy bash scripts/tests/audit-agent-config.sh` from the repository root.
The regression check uses an isolated home to exercise valid links, stale managed
links, archived assets, and independently maintained external links.

Static checks establish file structure and references.
Verify instruction discovery in a fresh client session after startup changes.
When changing skill selection or output guidance, inspect both clients against
representative requests such as these:

| Request | Expected scope and output |
|---|---|
| Fix a config value and report in Japanese | Implementation and native checks; ordinary Japanese reporting |
| Explain a design choice and its alternatives | A supported recommendation, relevant tradeoffs and concrete examples |
| Polish a Japanese article, or use a named writing skill | The requested writing workflow and its applicable checks |
| Review a diff with no actionable findings | The result and material verification limits; no automatic score or praise section |
| Review an English CLI in Japanese | Japanese review prose, exact CLI messages, assessment against the product's language policy |
| Record progress during a long implementation | Private task records; temporary coding-style mode remains in the conversation |

These cases guide static inspection and any separately authorized behavioral
evaluation. Record actual model, inputs, outputs, and limits when running such an
evaluation; a wording change or passing audit alone establishes no quality gain.

Keep current instructions and task references here. Store historical investigation
and adoption records under
[`archive/agent-history/`](../archive/agent-history/engineering-sources.md);
do not link them from task instructions. Consult them when the requested work
concerns that history, and check old decisions against the current request and
files.
