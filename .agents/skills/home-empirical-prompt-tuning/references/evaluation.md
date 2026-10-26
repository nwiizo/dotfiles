# Evaluation Evidence

Judge the result against observable criteria fixed before execution.

Before dispatch, check that the skill description's triggers are covered by
the body. Freeze the criteria and mark at least one essential requirement as
critical. A missing or partly met critical requirement means failure even if
the other criteria pass. Report checklist coverage as coverage of these cases,
not as general model accuracy.

## Validate the Acceptance Check

When a checker or model judge determines acceptance, validate that instrument
before using its scores to select an instruction version. Ordinary static
wording edits do not require building a grader.

- Use a known-good result and a plausible defective result for the same request.
  The defective result should work on ordinary input but violate the boundary
  being evaluated. Confirm the checker accepts the good result and rejects the
  defect for the intended reason; a checker crash or broken fixture is not detection.
- Accept different implementations that meet the request. Do not require code
  fences, a helper function, exact wording, or a particular structure unless
  that form is itself required. Test fixtures and output extraction are part
  of the instrument and can be wrong too.
- For a model judge, fix the rubric, model, and relevant settings. Hide candidate
  labels and expected answers, and vary presentation order when comparing pairs.
  Require a concrete artifact location or observable result for each finding.
  Check that the judge separates the reference results; this establishes only
  that distinction, not general accuracy. Prefer executable checks for behavior
  they can establish.
- Treat a missing, malformed, skipped, or unknown check as unobserved or an
  instrument error, not success. Report it separately from a candidate failure.
  If the instrument is wrong, correct it and rescore every affected version
  using retained artifacts; do not patch only the losing candidate's score.

Keep reference answers and hidden acceptance checks with the evaluator, outside
the implementer's readable workspace. They must check requirements justified by
the request and raw artifacts, not undisclosed implementation preferences.

## Judge the Candidate

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
- Establish the requested behavior and safety before comparing size or cost.
  A smaller stub is not an improvement. Keep test presence, test execution,
  and demonstrated defect detection separate; a keyword match or test count
  does not establish the latter two.

Rerun affected cases after a meaningful change. If repeated failures point to
a flawed task or missing capability, revisit that premise instead of adding
more prohibitions. Keep any changed acceptance criteria explicit and establish
a new comparison when the task changes.

For repeated rounds, keep a small per-target ledger of observed failures:
pattern, representative evidence, general fix rule, and rounds seen. Before
editing, identify the affected fixed criterion or observed execution problem.
If a pattern returns, inspect why the existing correction did not address it
before adding another rule. Change one causal theme at a time and use a fresh
executor for each round. Add an unused case when checking generalization.

Stop when the required behaviors are supported, a material blocker prevents
further evidence, or additional evaluation no longer justifies its cost.
Report coverage and remaining uncertainty. A successful example or stable
tool count does not establish convergence or broad reliability.
