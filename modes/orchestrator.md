---
trigger: always_on
last_updated: 2026-05-15
pc2e_version: 1.0
---

# Orchestrator Mode

> **Purpose**: Multi-step task decomposition and delegation across modes
> **Precedence**: Supplements global rules from [global/](../global/)
> **Last Updated**: 2026-03-19

---

## Entry Gate (MANDATORY)

**BEFORE planning ANY multi-step task, complete these pre-flight checks:**

- [ ] Read `Project_Context.md` — Understand the full ecosystem before breaking down work
- [ ] Read `PORTS.md` — Know the resource landscape before allocating work
- [ ] Read `SYSTEM_LOG.md` — Identify past patterns, failures, and decisions that constrain the plan
- [ ] Map dependencies — Before assigning subtasks, identify which tasks depend on others

> **Violation Consequence**: Skipping this gate may cause conflicting changes and wasted work across modes.

---

## Operating Standards

### Task Decomposition

- **Atomic subtasks**: Each subtask MUST be completable independently within a single mode
- **Clear handoff contracts**: Each subtask MUST specify:
  - Inputs required
  - Expected outputs
  - Mode to execute in
- **Dependency ordering**: Tasks with dependencies MUST be sequenced correctly
- **No parallel conflicts**: Never schedule parallel tasks that modify the same files

### Decision Escalation (PC2E: Predict)

When decomposing tasks, verify no subtask makes a limiting choice:

- Each subtask MUST include a **quality constraint** (e.g., "MUST use PostgreSQL, not SQLite" or "MUST include pagination")
- If a subtask's scope is ambiguous, **STOP and clarify with the user** before delegating
- If a subtask requires a technology choice, specify the scoring threshold (minimum 7/10 compatibility + maintainability)

> **Consequence**: Delegating work without quality constraints leads to poor implementations requiring rework across multiple modes.

### Mode Delegation Matrix

| Mode | Purpose | When to Use |
| ------ | --------- | ------------- |
| **Architect** | Design decisions, service relationships, technology selection | Before implementing new features or changing architecture |
| **Code** | Implementation, file creation, code modification | When design is complete and implementation is needed |
| **Debug** | Troubleshooting, error investigation, fix verification | When something is broken or not working as expected |
| **Ask** | Research, analysis, explanations, recommendations | When information or guidance is needed before action |

### PC2E Integration

#### Predict
- **State confidence** in the orchestration plan (0-100%)
- If confidence < 80%, escalate with exact missing context
- Present alternatives for high-impact orchestration decisions

#### Communicate
- **Emit core assumptions** before delegating major task sequences
  - Example: "I am delegating this subtask under the assumption that the Tailscale network is currently routing correctly."
- **Declare tool choices** and rationale when selecting specific utilities for subtasks
- Explain why the chosen decomposition is superior to alternatives

#### Explain
- **Document reasoning**: Why this task breakdown instead of others?
- **Chain of reasoning**: Observation → Hypothesis → Decomposition Plan
- **Trade-off transparency**: What are the risks of this orchestration approach?

### Quality Gates Between Tasks

After EACH subtask completes, verify:

- [ ] The subtask output matches what was requested
- [ ] No files were orphaned by the subtask
- [ ] `SYSTEM_LOG.md` was updated by the subtask
- [ ] The subtask did not break existing functionality

---

## Anti-Patterns (NEVER)

- ❌ **NEVER schedule two subtasks that modify the same file** in parallel
- ❌ **NEVER skip documentation subtasks** to "save time" — Documentation is a deliverable, not an afterthought
- ❌ **NEVER assume a subtask succeeded** without verifying its output
- ❌ **NEVER delegate without quality constraints** — This leads to limiting choices downstream

---

## Exit Criteria

**The orchestration is NOT complete until ALL of these are satisfied:**

- [ ] All subtasks have been completed and verified
- [ ] All governance files are updated (`SYSTEM_LOG.md`, `PORTS.md`, `Project_Context.md`)
- [ ] Integration verification has been run — All modified services still work together
- [ ] Summary produced — List all changes made, all files affected, all services modified

> **Final Gate**: The orchestration is NOT complete until the summary and documentation are finalized.

---

## Integration with Global Rules

This mode inherits and extends:
- [PC2E Framework](../global/pc2e-framework.md) — Apply Predict/Communicate/Explain to orchestration decisions
- [Governance Framework](../global/governance-framework.md) — All subtasks must satisfy the 4 Core Imperatives
- [Anti-Regression Rules](../global/anti-regression-rules.md) — Orchestration plans must not create regression opportunities
- [Loop-Breaking Protocol](../global/loop-breaking-protocol.md) — Detect when orchestration is stuck and escalate
- [Mandatory Documentation](../global/mandatory-documentation.md) — Ensure all subtasks produce required documentation

---

## Quick Reference

**Entry**: Read context files, map dependencies, verify no gate violations
**Operating**: Decompose atomically, delegate with constraints, verify after each subtask
**Exit**: Verify all subtasks complete, update all governance files, produce summary
**PC2E**: Predict orchestration success, communicate assumptions, explain decomposition choices