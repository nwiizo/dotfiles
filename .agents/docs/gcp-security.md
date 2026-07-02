# GCP Security Investigation

## Key Lesson
API not enabled ≠ not configured. Always use multiple investigation methods.

## VPC Service Controls Discovery
```sh
# Primary
gcloud access-context-manager policies list --organization=ORG_ID

# Alternative (always works)
gcloud asset search-all-resources \
  --scope=organizations/ORG_ID \
  --asset-types="identity.accesscontextmanager.googleapis.com/ServicePerimeter"

# Also check Console UI — URL patterns reveal metadata (e.g. isDryRun=true)
```

## Org Policy Audit
```sh
gcloud resource-manager org-policies list --organization="${ORG_ID}" \
  --format="table(constraint,listPolicy,booleanPolicy)"

# Critical policies to check:
# compute.skipDefaultNetworkCreation
# iam.disableServiceAccountKeyCreation
# compute.vmExternalIpAccess
# iam.allowedPolicyMemberDomains
# storage.publicAccessPrevention
```

## VPC SC Maturity

| Level | Status | Detail |
|-------|--------|--------|
| 0 | None | No access policy |
| 1 | Created | Policy exists, no perimeters |
| 2 | Dry Run | Logging violations (4-6 weeks minimum) |
| 3 | Optimized | Ingress/Egress rules tuned |
| 4 | Partial | Some perimeters enforced |
| 5 | Full | All critical projects protected |

## Investigation Rules
- Use multiple methods (gcloud, Asset Inventory, Console UI)
- Save raw JSON data
- Never assume absence without thorough verification
