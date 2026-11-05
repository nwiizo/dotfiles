---
name: home-web-quality-review
description: Web画面の実表示と主要操作から、アクセシビリティ・性能・SEO・配信の問題をレビュー、改善する。
---

# Follow the User Operation to Its Source

Resolve representative URLs, users, login states, devices, and key operations.
Review requests return findings; improvement requests include edits and checks.
Use authorized test data and avoid losing live form input.

For browser work use `aside-browser` and its current guide.
Read [Aside checks](references/aside-checks.md) for DOM, focus, and screenshots.
For performance use [measurement evidence](../home-systematic-debugging/web-performance-evidence.md);
for search visibility use [SEO checks](references/search-visibility.md);
for browser/network issues use [delivery checks](references/browser-delivery.md).
Select the relevant path rather than running every audit.

Check keyboard reachability, semantic names and states, dialog focus and return,
form errors and retained input, zoom/narrow screens, and reduced-motion behavior
where they affect the requested operation.
Prefer native elements and add ARIA only where needed.

Trace a demonstrated problem into the source.
Scores, screenshots, and accessibility trees provide different evidence;
automated scores alone do not establish WCAG conformance or actual usability.
Keep private screens' intentional noindex settings.

After a fix, repeat the affected operation under matching conditions.
Report location, reproduction, impact, result, and untested input methods or devices.
