# Agent Trace Efficiency

Use this when a prompt or workflow produces correct results but costs too much,
takes too long, or repeats work. Read the final artifact and relevant execution
events together: a cheap incorrect result is not an improvement, and a different
valid tool sequence is not a failure merely because it differs from a reference.

## Compare the Same Job

- Freeze the request, success criteria, model/version, input size, tool versions,
  and relevant cache state. Record missing metadata rather than inventing it.
  Compare ordinary and difficult cases; do not optimize only the cheapest example.
- Keep outcome quality, elapsed time, model/tool usage, retries, and estimated
  cost separate. Trace duration sums can double-count nested or overlapping work;
  identify the path that determines completion and the source of any missing time.
- Distinguish billed cost from an estimate using tokens and a price table. Record
  the table date, model mapping, cache rates, and unavailable usage. Unknown models
  or absent spans are unknown costs, not zero. Profiler savings may overlap;
  do not add them together as if each saved a different call.

## Inspect Before Changing

- Repeated arguments can be waste, polling, verification after a write, or a retry.
  Check the returned state, freshness requirements, and side effects. Reuse a
  result only while the state and authorization it depends on remain valid.
- Sibling spans and serial calls are candidates for investigation, not proof of
  independence. Check data dependencies, shared files/resources, ordering,
  cancellation, rate limits, and side effects before parallelizing.
- Reduce context by removing repeated or irrelevant material. Preserve the
  constraints, source evidence, and failure details needed to do the job.
  A token budget alone cannot establish which information is unnecessary.
- Consider a smaller model only after evaluating the same acceptance criteria,
  including difficult cases. A short response or low token count does not prove
  that the underlying decision is easy.

Change one causal theme, repeat comparable cases, and report measured before/after
values with the quality result. Treat estimated savings as a hypothesis until
rerun evidence supports them. A profiler score does not establish correctness.

## Concept Sources

Reviewed 2026-10-27: [agent-house's June 20 implementation](https://github.com/addyosmani/agent-house/blob/dc29aa52b40d1830ba11212e333e7dacd3622257/src/audit/audits/parallelizable.ts)
motivated trace-based optimization and inspecting the elapsed critical path.
Its sibling-span heuristic is not an independence guarantee; the checks above
are required before applying that suggestion. [Agent Engineer, lesson 9](https://github.com/addyosmani/agent-engineer/blob/57522790c1c3d8120d376791f1610ffe7682e027/09-evaluating-and-testing-agents/README.md)
(substantive chapter added 2026-03-19, updated 2026-07-16) motivates examining both
outcomes and trajectories without requiring an exact sequence. Use the current
[OpenTelemetry trace model](https://opentelemetry.io/docs/concepts/signals/traces/)
to interpret span relationships; parentage alone does not establish safe concurrency.
