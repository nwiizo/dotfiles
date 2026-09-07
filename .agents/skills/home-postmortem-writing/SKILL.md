---
name: home-postmortem-writing
description: Write or review incident postmortems from timelines, impact evidence, and response records, with contributing factors and verifiable follow-up actions.
---

# Postmortem Writing

Produce an incident account that explains what happened, what affected users,
and which changes could prevent or reduce a recurrence. Use the team's existing
template, severity definitions, and publication process when available.

## Evidence and Analysis

- Reconcile event times, time zones, incident duration, and impact measurements.
  Keep estimates, unknowns, and hypotheses distinguishable from verified facts.
- Separate the trigger, failure mechanism, contributing conditions, and recovery.
  Do not force every incident into one root cause or exactly five "whys."
- Explain decisions using the information responders had at the time.
  Avoid attributing motives or substituting individual blame for causal analysis.
- Connect follow-up actions to an observed failure or response gap. Record the
  owner, completion evidence, and due date when known; do not invent assignments
  or tickets to fill a template.
- Distinguish recovery from permanent remediation. Do not claim that rollback
  proved a cause or that absence of reports proves absence of data loss.

If no template exists, use the needed parts of: impact, timeline, causal analysis,
detection and response, follow-up actions, and supporting evidence. Match detail
to the incident; meeting agendas and fixed response deadlines are not mandatory.

Drafting the postmortem does not authorize posting messages or creating external
tickets. Preserve private incident material in the authorized workspace.
