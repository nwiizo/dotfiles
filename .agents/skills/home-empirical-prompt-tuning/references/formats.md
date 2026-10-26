# Reporting an Instruction Evaluation

Lead with the observed behavior and its implication for the change.
A compact table is useful when comparing several cases:

| Case | Instruction version | Observed outcome | Supporting artifact or check | Limit |
|---|---|---|---|---|

Report the substantive instruction change, tested coverage, failures, and any
unavailable execution or metrics. Separate static findings from executed cases.
No iteration-by-iteration presentation or fixed scorecard is required.

Avoid claiming that fewer tokens prove better decisions, that all discretion
indicates ambiguity, or that a small successful sample establishes model-wide
reliability. State whether a comparison used different instruction versions or
only checked the revised version.

When a grader or model judge was used, report the reference-case check, its
limits, and any rescoring after an instrument correction. Distinguish candidate
failures from unavailable checks or timeouts, including their counts when
presenting rates. State which instruction-loading and isolation conditions were
verified; do not label a shared, inherited skill as an absent baseline.
