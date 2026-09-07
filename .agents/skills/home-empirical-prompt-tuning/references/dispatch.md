# Independent Evaluator Setup

Use a fresh evaluator for each compared instruction version. Give it the
instruction path, realistic user request, raw artifacts, permitted workspace,
and actual task constraints. Do not provide the expected conclusion, previous
findings, or a suggested fix.

Keep evaluation outputs in an isolated temporary directory. Make ownership and
side-effect limits explicit; a simulated production incident never authorizes
access to a live service.

Ask the evaluator to complete the task and return:
- the artifact or result and evidence supporting it;
- incomplete work, ambiguous instructions, and environment limitations;
- material choices it made using its own judgment.

The caller owns acceptance criteria and checks the result independently.
A test about asking for permission must not tell the evaluator whether to ask.

Record inherited instructions and model/tool settings that affect comparability.
A new subagent may still inherit global instructions; disclose that limit.
Do not silently substitute another model when the comparison depends on one.

If an evaluator fails or times out, record the missing case. Retry when a
specific transient cause makes that useful, without duplicating running work.
If delegation is unavailable or not authorized, perform static review and
report that behavioral execution was not tested.
