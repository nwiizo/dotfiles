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

Reviewed 2026-10-27 against [Web Quality Skills, 2026-08-24](https://github.com/addyosmani/web-quality-skills/blob/c6b06ad1285cd6b129b58455b2eec96ab6b67fa7/skills/performance/SKILL.md)
and [Google's field/lab explanation](https://web.dev/articles/lab-and-field-data-differences).
The adopted idea is evidence selection, not a fixed score, resource budget, browser
version, or requirement to install a particular MCP server.
