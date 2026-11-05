---
name: home-incident-runbook-templates
description: Write service-specific incident procedures for diagnosis, mitigation, recovery, verification, and escalation.
---

# Write an Executable Service Runbook

Derive service, environment, commands, permissions, contacts, and thresholds from
existing configuration and operations records.
For each consequential step state its precondition, exact target, action,
expected observation, and failure path.

Separate diagnosis from state-changing recovery.
Before destructive recovery, identify impact, authorization, selected resources,
and a recovery path. Rollback includes schema and data compatibility.

Verify recovery through affected user operations and relevant health signals.
Use actual escalation policy; mark proposed decisions and unexecuted commands.
Document ownership and validation status.
Writing a runbook does not authorize running recovery against a live service.
During an active incident, prioritize restoration over producing a complete document.
