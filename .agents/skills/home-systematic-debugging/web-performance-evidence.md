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

For measurement interpretation, use [Google's field/lab explanation](https://web.dev/articles/lab-and-field-data-differences)
(reviewed 2026-10-27). For provenance and adaptation decisions when maintaining
this guide, see [engineering sources](../../docs/engineering-sources.md).
