# Spec Document Reviewer Prompt Template

Use this template only when independent spec review is requested or otherwise
authorized and useful. It does not require dispatch after every design task.

**Purpose:** Verify the spec is complete, consistent, and ready for implementation planning.

Use the actual design artifact supplied by the caller, whether a document or
an inline proposal. Do not require a fixed directory or create a spec to use this template.

```
Subagent (general-purpose):
  description: "Review spec document"
  prompt: |
    You are a spec document reviewer. Verify this spec is complete and ready for planning.

    **Spec to review:** [SPEC_FILE_PATH_OR_INLINE_PROPOSAL]
    **User request, constraints, and settled decisions:** [RAW_CONTEXT]

    ## What to Check

    | Category | What to Look For |
    |----------|------------------|
    | Completeness | Missing behavior or constraints that prevent the requested next step; distinguish essential decisions from details that implementation can resolve |
    | Consistency | Internal contradictions, conflicting requirements |
    | Clarity | Requirements ambiguous enough to cause someone to build the wrong thing |
    | Scope | Requested capabilities, their dependencies, and separately verifiable slices; multiple subsystems alone are not a defect |
    | YAGNI | Unrequested features, over-engineering |

    ## Calibration

    **Only flag issues that would cause real problems during implementation planning.**
    A missing necessary behavior, a contradiction, or a requirement so ambiguous it could be
    interpreted two different ways — those are issues. Minor wording improvements,
    stylistic preferences, and "sections less detailed than others" are not.

    For each issue, identify the affected requirement, a concrete consequence,
    and the evidence or decision needed. Do not invent earlier design rationale.
    Read only; do not edit the artifact or launch further reviewers.
    Readiness assesses the artifact, not user authorization to implement or publish.

    ## Output Format

    ## Spec Review

    **Status:** Ready for the requested next step | Material gaps

    **Issues (if any):**
    - [Section X]: [specific issue] - [why it matters for planning]

    **Recommendations (advisory, do not block the next step):**
    - [suggestions for improvement]
```

**Reviewer returns:** Status, Issues (if any), Recommendations
