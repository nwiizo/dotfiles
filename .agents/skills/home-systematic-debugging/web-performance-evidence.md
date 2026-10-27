# Web Performance Evidence

Separate real-user measurements, controlled browser runs, and source-based
hypotheses. They answer different questions and cannot substitute for each other.

- Use available field data to identify affected routes, devices, releases, and
  user actions. Record the aggregation window, population, and whether the data
  describes a URL or an origin. Missing field data means unknown impact, not good
  performance; proceed with reproducible lab diagnosis when practical.
- Reproduce the relevant action in a browser trace. Record device/network settings,
  cache state, authentication, data, and tool version. Compare equivalent conditions
  and repeat noisy measurements before attributing a difference to the change.
- A measurement from one browser, including a PerformanceObserver snippet, is a
  session observation. It is not production RUM merely because it uses the same API.
  A Lighthouse score or TBT improvement does not establish better field INP.
- Follow the trace to the limiting request or main-thread work and inspect its
  source. Change the measured cause rather than applying a general bundle-size
  budget or framework optimization regardless of the actual bottleneck.
- Report source inspection as a hypothesis if the page cannot run. After a lab
  improvement, keep real-user impact pending until post-change field data covers
  the relevant population and period; do not compare an old aggregate as though
  it measured the new release alone.

## Follow the metric to the cause

| Signal | Diagnose before choosing a change |
|---|---|
| LCP | Identify the actual element, then separate server response, resource discovery delay, transfer duration, and render delay. Compressing an image does not fix time spent waiting for rendering. Avoid lazy loading the observed LCP image; add preload only for demonstrated late discovery, checking for duplicate requests and bandwidth competition. |
| INP | Reproduce the affected click, tap, or key interaction. Separate input delay, handler processing, and presentation delay. Loading-only tests and TBT do not cover the entire interaction; verify the user's result still completes after yielding or splitting work. |
| CLS | Inspect the shift's timing and cause, not just the moved element. Content inserted above it may be responsible. Include relevant post-load interactions; reserve suitable space without hiding errors or dynamic content. |

Keep URL-level and origin-level field data distinct, including device and p75
aggregation. If only origin data exists, it does not prove the specific route fails.
When field and lab disagree, investigate the missing device, interaction, cache,
or user population instead of forcing their values to match.

Use installed trace or audit capabilities and check their actual supported modes.
Do not infer performance measurement from an accessibility/SEO audit capability.
Avoid reload-based collection on unsaved forms; use a separate permitted test state
or a supported current-state mode. Record temporary emulation settings and restore
them after the check. External measurement services are for public URLs, not private
routes or authenticated sessions.

Speculative loading is a separate navigation optimization: measure useful hits,
wasted bytes, server work, and early side effects before expanding it. Do not
preload every asset or prerender every link to improve a score. Preserve the
project's budgets rather than importing fixed bundle-size or timing limits.

For metric-specific diagnosis, see [LCP](https://web.dev/articles/optimize-lcp),
[INP](https://web.dev/articles/optimize-inp), and [CLS](https://web.dev/articles/optimize-cls)
(reviewed 2026-10-27).
For measurement interpretation, use [Google's field/lab explanation](https://web.dev/articles/lab-and-field-data-differences)
(reviewed 2026-10-27). For provenance and adaptation decisions when maintaining
this guide, see [engineering sources](../../docs/engineering-sources.md).
