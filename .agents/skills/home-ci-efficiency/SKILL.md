---
name: home-ci-efficiency
description: CIの待ち時間・総実行量・失敗率を分けて測り、必要な検出能力を保って改善する。単発のテスト失敗はdebuggingを使う。
---

# Improve CI from Comparable Measurements

Read workflows, called scripts, lockfiles, dependencies, permissions, and actual
run evidence. Fix the comparison conditions before changing the workflow.

Separate elapsed feedback time, total runner work, queueing, setup, compilation,
tests, artifact transfer, first-attempt failures, retries, and missing results.
Runner minutes alone do not establish billed savings.

Locate the critical dependency path. Compare equivalent inputs and cold/warm
cache conditions, including restore/save cost. Check repeated setup and shared
fixture contention before adding parallelism.
For Rust compilation, use matching profiles/features/targets and existing
`cargo build --timings` output when appropriate; preserve user build artifacts.

Map every required check to its behavior, command, and execution condition.
Inspect changed assertions, thresholds, skip paths, matrices, and lint exceptions.
Retain equivalent detection when moving or removing a check; green status alone
does not prove equivalence.
Keep cache trust boundaries and release/deployment cancellation behavior explicit.

Validate relevant success, failure, and cache-miss paths.
Compare multiple equivalent runs when making performance claims.
If live runs are unavailable, report static validation and expected effects as such.
