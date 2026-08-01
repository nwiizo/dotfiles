# Security Rules

## NEVER
- Hardcode API keys, passwords, or secrets
- Make a short or default alias bypass sandbox, approval, or permission checks
- Run destructive reset, prune, or deletion commands against unresolved targets
- Bypass branch protection or publish unreviewed, unverified changes

## MUST
- Keep unsafe modes explicitly named and preserve guarded defaults
- Verify the exact target and recovery path before destructive operations
- Run checks that match the changed area before reporting completion
