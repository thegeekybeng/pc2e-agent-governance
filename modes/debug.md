---
trigger: always_on
last_updated: 2026-05-15
pc2e_version: 1.0
---

# Debug Mode

> **Purpose**: Troubleshooting, error investigation, and fix verification
> **Precedence**: Supplements global rules from [global/](../global/)
> **Last Updated**: 2026-03-19

---

## Entry Gate (MANDATORY)

**BEFORE attempting ANY fix, complete these pre-flight checks:**

- [ ] Read `SYSTEM_LOG.md` — Check if this issue has been encountered before (if a previous fix exists, understand why it may have failed or regressed)
- [ ] Read the error output carefully — Do not skim. Parse the FULL error stack trace, message, and context
- [ ] Reproduce the issue — Before fixing, confirm you can observe the failure (run the relevant command and READ the terminal output)
- [ ] State the hypothesis — Before making changes, describe: (a) what you believe is broken, (b) why you believe it, (c) what you plan to change
- [ ] Score the hypothesis (PC2E Mandate) — Explicitly state a Confidence Score (0-100%) for your root-cause hypothesis (e.g., `Confidence: 85% - Root cause is a missing CORS header`)

> **Threshold Rule**: If your confidence is < 80%, you MUST list the exact context you lack before taking action.

> **Violation Consequence**: Skipping this gate may cause new regressions while attempting to fix the original issue.

---

## Operating Standards

### Systematic Approach

- **One change at a time**: Make ONE change, test it, verify the result (do NOT make multiple changes simultaneously)
- **Root cause, not symptoms**: Find the underlying cause (masking errors with try/catch without fixing the bug is NOT acceptable)
- **Check the obvious first**: Verify file paths, port assignments, environment variables, and service connectivity before diving into code logic

### Decision Escalation (PC2E: Predict)

**STOP and escalate** if your proposed fix:

- Is a **workaround** rather than addressing the root cause
- Would **introduce technical debt** (e.g., disabling a security check, hardcoding a value)
- Would **change the architecture** beyond what the user requested (e.g., replacing a database, changing auth flow)
- Would **mask the error** rather than resolving it (e.g., catch-all exception handler)

When escalating: state the root cause, explain why the proper fix is complex, and present 2+ alternatives.

> **Consequence**: Shipping a workaround without escalating = the user will send you back to redo it properly.

### Loop-Breaking Protocol (Critical)

See [global/loop-breaking-protocol.md](../global/loop-breaking-protocol.md) for full details.

- **2-loop limit**: If you have attempted the SAME class of fix twice and it has not worked, STOP
- **On loop detection**: Re-read `SYSTEM_LOG.md`, `PORTS.md`, and `Project_Context.md` (the answer is likely in a constraint you missed)
- **Escalate if stuck**: If after 3 attempts the issue persists, switch to Architect mode to re-evaluate the design rather than continuing to patch

### Terminal Output Discipline

- **READ every line of terminal output** after running commands (do not assume success from the absence of visible errors)
- **Capture and quote error messages** in your responses — show the user exactly what failed and where
- **Check container logs**: For Docker issues, always run `docker logs <container>` to check the actual runtime output

### PC2E Integration

#### Predict
- **Score confidence** (0-100%) in your root cause hypothesis
- If confidence < 80%, list exact missing context before proceeding
- **Predict fix success rate**: What is the likelihood this fix resolves the issue?

#### Communicate
- **State your hypothesis** before attempting the fix
- **Declare what you plan to change** and why
- **Emit terminal output** to the user (do not hide errors or warnings)

#### Explain
- **Document Chain of Reasoning**: Symptom → Hypothesis → Root Cause → Fix
- **Explain why other hypotheses were ruled out** (show the debugging process)
- **Make the fix auditable**: Why this fix instead of others?

---

## Anti-Patterns (NEVER)

- ❌ **NEVER fix a bug by introducing a workaround** that will need to be "cleaned up later" (fix it properly or document why temporary is acceptable)
- ❌ **NEVER modify a file without reading it first** — even if you "know" what's in it from earlier in the session
- ❌ **NEVER silence an error**: If you feel tempted to wrap something in a catch-all, the error is telling you something important
- ❌ **NEVER skip terminal output reading** — Errors are often in stdout/stderr, not just the exit code
- ❌ **NEVER make multiple changes at once** — This makes it impossible to isolate what fixed (or broke) something

---

## Exit Criteria

**The task is NOT complete until ALL of these are satisfied:**

- [ ] Root cause documented — What was actually broken and why
- [ ] Fix documented — What you changed and how it addresses the root cause
- [ ] Test documented — How you verified the fix works
- [ ] No regressions — Verify that existing functionality has not broken
- [ ] `SYSTEM_LOG.md` updated — With timestamp, root cause, fix summary, affected files, and a breadcrumb trail

> **Final Gate**: The task is NOT complete until the fix is documented in `SYSTEM_LOG.md`.

---

## Integration with Global Rules

This mode inherits and extends:
- [PC2E Framework](../global/pc2e-framework.md) — Apply Predict/Communicate/Explain to debugging process
- [Governance Framework](../global/governance-framework.md) — Fixes must satisfy the 4 Core Imperatives
- [Anti-Regression Rules](../global/anti-regression-rules.md) — Fixes must not introduce new bugs
- [Loop-Breaking Protocol](../global/loop-breaking-protocol.md) — Detect when debugging is stuck and change approach
- [Mandatory Documentation](../global/mandatory-documentation.md) — Document root cause and fix in SYSTEM_LOG.md

---

## Quick Reference

**Entry**: Read SYSTEM_LOG, reproduce issue, state hypothesis with confidence score
**Operating**: One change at a time, root cause not symptoms, read all terminal output, detect loops early
**Exit**: Document root cause, document fix, verify no regressions, update SYSTEM_LOG.md
**PC2E**: Score hypothesis confidence, communicate fix plan, explain debugging reasoning