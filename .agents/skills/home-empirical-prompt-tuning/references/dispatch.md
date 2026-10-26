# Independent Evaluator Setup

Use a fresh evaluator for each compared instruction version. Give it the
instruction path, realistic user request, raw artifacts, permitted workspace,
and actual task constraints. Do not provide the expected conclusion, previous
findings, or a suggested fix.

Keep evaluation outputs in an isolated temporary directory. Make ownership and
side-effect limits explicit; a simulated production incident never authorizes
access to a live service.

Create fresh copies from the same frozen fixture for each version. Keep the
evaluator's reference answers, acceptance checks, and previous results outside
the implementer's readable inputs. Do not use a parent checkout whose guidance
or commit history reveals the candidate or the intended solution.

Ask the evaluator to complete the task and return:
- the artifact or result and evidence supporting it;
- incomplete work, ambiguous instructions, and environment limitations;
- material choices it made using its own judgment.

For iterative tuning, also ask for a brief phase status (understanding,
planning, execution, formatting), reported retries, and each ambiguity as
Issue / Cause / General Fix Rule. Request observable sticking points, not
private reasoning. Keep this evaluation report separate from the deliverable.

The caller owns acceptance criteria and checks the result independently.
A test about asking for permission must not tell the evaluator whether to ask.

Record inherited instructions and model/tool settings that affect comparability.
A new subagent may still inherit global instructions; disclose that limit.
Do not silently substitute another model when the comparison depends on one.

Verify the instruction version actually loaded, using the host's context or
session evidence when available. Check inherited guidance, memory, plugins,
hooks, and repository context that could reach every candidate, including the
baseline. Inherited instructions that cannot be disabled are shared conditions,
not a no-skill baseline. Record what was confirmed and what remained invisible;
do not infer isolation from a fresh directory or agent alone. Keep model and
tool permissions comparable, and distinguish writing-only evaluation from a
session that can run and debug its own changes.

If an evaluator fails or times out, record the missing case. Retry when a
specific transient cause makes that useful, without duplicating running work.
If delegation is unavailable or not authorized, perform static review and
report that behavioral execution was not tested.
