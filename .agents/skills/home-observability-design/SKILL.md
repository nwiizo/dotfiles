---
name: home-observability-design
description: 利用者の結果と調査したい問いから、メトリクス・ログ・トレース・SLI/SLOを設計、レビューする。
---

# Measure What Changes a Decision

Read existing instrumentation and operations.
State what observation would let whom make which decision.
Define success, events, exclusions, period, and observation boundaries.
Separate acceptance, attempts, processing completion, and user-visible results.
For GraphQL, inspect HTTP status and application outcomes, including combined
data and errors.

Use metrics for bounded aggregates, logs for individual state changes, and
traces for causal paths and latency.
Align numerator and denominator; zero traffic, missing data, and failures differ.
Choose SLOs and alert actions from actual expectations, ownership, and evidence.

Bound metric labels by permitted values; avoid request IDs, user IDs, raw URLs,
and email addresses. Check label combinations, histogram buckets, and instances.
For logs and spans, consider purpose, secrecy, length, allowed characters, and
cardinality. Authentication does not make self-reported headers trustworthy;
a length limit does not bound the number of distinct values.

Use parent spans and span links according to actual causality, including retries
and batches. In Rust, check async span attachment across await boundaries.
Sampling and exporter loss constrain observations: biased trace samples do not
directly estimate all-request failure rates, and tail sampling cannot restore
traces already discarded upstream.

## Request and Cancellation Boundaries

Inspect failures before observation starts, including authentication, extraction,
and resource waits. Name durations for what they actually include and preserve
unreached stages rather than substituting zero.
Synchronize timing tests with the stage and resource release being measured;
sleep from request start is insufficient.

Distinguish response creation, delivery, future drop, SQL completion, and resource
return. A dropped-future test alone does not prove real disconnection or SQL
cancellation. Started-minus-finished includes window edges, in-flight work,
export loss, and process exit; correlate IDs before counting cancellations.

Verify local record generation, shared-environment receipt, and dashboard
aggregation and operations separately.
Record sampling scope and mixed-version deployment periods.
Do not claim useful aggregation over an attribute not yet received.

## Verify the Decision Path

Exercise relevant normal, failure, slow, retry, empty, and telemetry-loss cases
with isolated test data and notification targets.
Confirm data arrives and supports the intended distinction.
Compare retention, sampling, application overhead, collection, storage, and query
cost against the lost diagnostic ability.

Report observed capability and remaining blind spots.
Read current [tracing async guidance](https://docs.rs/tracing/latest/tracing/span/struct.Span.html#in-asynchronous-code),
[OpenTelemetry sampling](https://opentelemetry.io/docs/concepts/sampling/),
or [SLO guidance](https://sre.google/workbook/implementing-slos/) when needed.
