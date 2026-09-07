---
name: home-incident-runbook-templates
description: Create service-specific incident runbooks with diagnosis, recovery, rollback, and escalation steps. Use for response-procedure authoring; an active incident does not require writing a full runbook first.
---

# Incident Runbooks

Write procedures an on-call engineer can use with the actual service, deployment
environment, permissions, and team escalation policy. Resolve those facts from
existing configuration and runbooks; identify missing operational decisions.

## Procedure Requirements

For each consequential step, give the relevant precondition, exact target,
action, expected observation, and what to do if it fails. Keep diagnosis and
state-changing recovery distinguishable.

- Derive commands, identifiers, dashboards, contacts, and thresholds from the
  target environment. Do not substitute fictional production defaults.
- Before destructive actions, specify the selected resources, impact, required
  authorization, and recovery path. A count threshold alone is not a safe basis
  for terminating sessions, deleting data, or failing over a database.
- Rollback instructions must account for data and schema compatibility.
- Verify recovery through affected user operations and relevant health metrics,
  not merely a successful command or running process.
- Use team-defined severity, escalation, and update intervals. If absent, mark
  proposed policy as a decision rather than inventing an established practice.
- Record ownership and actual validation status. Label unexecuted commands;
  documentation work does not authorize testing recovery against production.

A useful layout is: scope and impact, triage, conditional mitigation, verification
and rollback, escalation, and communication. Omit sections that add no useful
decision or action. Use `home-postmortem-writing` when an incident review is requested.
