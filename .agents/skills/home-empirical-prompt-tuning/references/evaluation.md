# Evaluation Evidence

Judge the result against observable criteria fixed before execution.

- Mark each criterion met, unmet, or unobserved. Identify safety and authority
  requirements whose failure invalidates an otherwise useful result.
- Verify artifacts and command outcomes directly. Self-reported clarity and
  retries can explain a failure but do not establish correctness.
- Treat reasonable discretion as expected model behavior, not automatically as
  an instruction gap. Add guidance only when a choice caused a concrete problem.
- Compare tool use and duration only when input, environment, and task are
  comparable. More reads may reflect a harder task; timing is not a measure of
  cognitive load or instruction quality.
- Do not invent missing usage metrics or turn a few checklist items into a
  precise-looking model accuracy estimate.

Rerun affected cases after a meaningful change. If repeated failures point to
a flawed task or missing capability, revisit that premise instead of adding
more prohibitions. Keep any changed acceptance criteria explicit and establish
a new comparison when the task changes.

Stop when the required behaviors are supported, a material blocker prevents
further evidence, or additional evaluation no longer justifies its cost.
Report coverage and remaining uncertainty. A successful example or stable
tool count does not establish convergence or broad reliability.
