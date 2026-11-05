---
name: nwiizo-coding-style
description: 既存コードを生かした最小実装と品質レビューを行う。Rustでは型・所有権・依存と構造診断を扱う。
argument-hint: "[lite|full|ultra|off|review|audit|debt|gain|help|default <mode>] [対象・依頼]"
license: MIT
---

# Make the Smallest Clear Change That Works

Read the actual input-to-result path, callers, existing tests, and project
requirements before choosing an implementation.
Prefer existing code, standard language/platform facilities, then a suitable
installed dependency. Add only what the requested behavior needs.
Keep validation, recovery, security, accessibility, and required performance.

## Modes and Operations

Default mode: `full`. Carry the current conversation's selected mode forward.
In a new conversation, use `NWIIZO_CODING_STYLE_DEFAULT_MODE` if it is one of
`lite`, `full`, `ultra`, or `off`; otherwise report the invalid value and use full.

| Input | Result |
|---|---|
| Skill name only | Show the current mode |
| lite | Implement the request; mention a simpler viable option if useful |
| full | Choose the simplest complete implementation from the existing system |
| ultra | First seek removals and standard replacements, preserving requirements |
| off / stop / normal mode | Stop continuing this skill's mode |
| default MODE | Update this source's default; preserve the conversation mode |
| review / audit / debt / gain / help | Execute that operation without changing mode |

Read [operations](references/operations.md) only for the requested reporting
operation. `off` still permits an explicitly requested operation.
These are conversation instructions, not shell commands; quoted text does not
change modes. Do not persist conversation state to disk.

## Implementation Decisions

Follow data through affected readers, writers, exports, and callers.
For a confirmed defect, search related paths and preserve intentional differences.
Prefer visible names and simple control flow over compressed expressions.
A single caller does not by itself make an abstraction unnecessary.

Retain consequential reasons and limits near their owner.
For an intentional shortcut use
`nwiizo-coding-style: <limit>; <condition and action for revisiting>`,
or the project's established format. Ordinary reuse needs no such comment.

Read conditional guidance only when it changes this task:
[decision evidence](references/decision-evidence.md) for conflicting intent,
[trust boundaries](references/trust-boundaries.md) for external input leading
to execution, deletion, or authenticated changes, and
[compatibility](references/compatibility-updates.md) for public APIs or dependencies.
For unresolved implementation assumptions, use the
[preflight](references/implementation-preflight.md) rather than repeating settled design.

## Rust

Check edition, MSRV, features, toolchain, and CI.
Use [Rust design](references/rust-design.md) for ownership, types, errors, and
dependencies, and [edition guidance](references/rust-2024.md) when relevant.
For Rust structural changes and review/audit, run `similarity-rs` and
`cargo-coupling` through [structural analysis](references/rust-analysis.md).
Inspect actual findings before changing boundaries; retain the requested scope.

## Verification and Result

For a reproducible bug or substantial behavior change with a practical test seam,
use `home-test-driven-development`. Use native validation for configuration.
Complete required project checks and exercise the changed user operation.
Repeat passing checks after a relevant change, failure, or unresolved concern.
If completion evidence is uncertain, use [claim verification](references/completion-evidence.md).
For review findings to apply, use [finding resolution](references/review-findings.md).

Finish authorized implementation without adding routine approval rounds.
Report the result, current verification, and material limits in concise prose.
Review-only requests return supported findings.
For measured instruction effects use [regression cases](references/regression-cases.md)
with an authorized evaluation.
