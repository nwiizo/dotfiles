---
name: home-karpathy-guidelines
description: 曖昧な実装依頼や最小実装・YAGNIの依頼で、結果を左右する前提と検証方法を整理する。方針が決まった通常の変更では追加の手順を課さない。
license: MIT
---

# Implementation Preflight

Use this preflight when uncertainty could change the implementation, not as a
ceremony before every edit.

- Resolve facts from the repository and current conversation first. State only
  assumptions that affect the outcome; ask about choices evidence cannot settle.
- Identify the observable result and how to verify it. For dependent work, give
  a short plan whose steps lead to that result.
- After tracing the affected flow, stop at the first sufficient option: no new
  code, existing code, standard library, native feature, installed dependency,
  then the minimum clear implementation.
- Preserve trust-boundary validation, data-loss prevention, security,
  accessibility, explicit requirements, and necessary verification.
- Keep each change tied to the requested result. Include dependent fixes, but
  avoid speculative features, abstractions, and unrelated cleanup.
- Once the necessary choices are resolved, continue authorized implementation.
  Do not ask for another approval of the plan or repeat settled discovery.

A small diff is useful when it remains clear and correct. Do not replace
engineering judgment with a line count or a fixed number of questions.

Adapted from [Karpathy's observations](https://x.com/karpathy/status/2015883857489522876),
[andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills),
and [Ponytail](https://github.com/DietrichGebert/ponytail).
