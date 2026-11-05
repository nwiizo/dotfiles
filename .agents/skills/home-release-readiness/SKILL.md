---
name: home-release-readiness
description: リリースやデプロイの配布物・利用側の動作・段階展開・復旧を確認する。通常の編集完了やcommitだけには追加しない。
---

# Verify What Users Will Receive

Resolve the repository, exact revision/version, registry or environment, and
supported platforms. Check that required verification belongs to that artifact.
Preparation alone does not authorize publication; carry explicit publication
authorization forward.

Inspect the actual archive, crate, binary, or image and its required files.
Verify installation and affected operations from that artifact with isolated
home/configuration and credentials. A development binary is separate evidence.
For crates, use the existing package-specific procedure and dry run; a dry run
does not upload a release.

Map recovery for code, configuration, stored data, and external side effects.
Check old/new data compatibility and retry behavior.
Choose staged rollout and stop conditions from actual user risk and telemetry
when appropriate, rather than a fixed percentage or waiting period.

After a timed-out publication, inspect target state before retrying.
Separate registered, in progress, absent, and unobservable outcomes.
After publication, retrieve the requested version and verify affected consumer
behavior. Report preparation, publication, and post-release verification separately.
