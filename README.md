# .agent Rule Precedence and Navigation

> **Last Updated**: 2026-03-19
> **PC2E Version**: 1.0

---

## Rule Application Order

The `.agent` framework applies rules in the following precedence order:

1. **Global rules** ([global/](global/)) - Always apply to ALL modes and workflows
2. **Mode-specific rules** ([modes/](modes/)) - Apply when operating in that specific mode
3. **Workflow rules** ([workflows/](workflows/)) - Apply for specific task types
4. **In conflicts**: Higher-precedence rules win

### Example
If a global rule states "NEVER use root containers" and a workflow suggests "use root for quick testing", the global rule takes precedence.

---

## Quick Navigation

### For New Users
- **Start here**: [PC2E Framework](global/pc2e-framework.md) - Understand the core philosophy
- **Then read**: [Governance Framework](global/governance-framework.md) - Learn the 4 Core Imperatives

### For Active Development
- **Starting a task?** Check [Governance Framework](global/governance-framework.md)
- **In Orchestrator mode?** See [modes/orchestrator.md](modes/orchestrator.md)
- **In Architect mode?** See [modes/architect.md](modes/architect.md)
- **In Code mode?** See [modes/code.md](modes/code.md)
- **In Debug mode?** See [modes/debug.md](modes/debug.md)
- **In Ask mode?** See [modes/ask.md](modes/ask.md)

### For Specific Tasks
- **Working with Docker?** See [Docker Workflow](workflows/docker-compose-workflow.md)
- **Need to document a technology decision?** Use [TDR Template](templates/tdr-template.md)
- **Scoring a technology?** Use [Scoring Rubric](templates/scoring-rubric.md)

---

## File Organization

### [global/](global/)
**Universal rules that apply to ALL modes**

Contains:
- **pc2e-framework.md** - Core PC2E philosophy (Predict, Communicate, Explain)
- **governance-framework.md** - 4 Core Imperatives (Scalability, Security, Zero Debt, Privacy)
- **anti-regression-rules.md** - Patterns to avoid regressions
- **loop-breaking-protocol.md** - How to detect and escape stuck states
- **mandatory-documentation.md** - Documentation requirements

### [modes/](modes/)
**Context-specific behavior for different operating modes**

Contains:
- **orchestrator.md** - Multi-step task decomposition and delegation
- **architect.md** - Design decisions and technology selection
- **code.md** - Implementation, file creation, code modification
- **debug.md** - Troubleshooting, error investigation, fix verification
- **ask.md** - Research, analysis, explanations, recommendations

Each mode file includes:
- **Entry Gates** (MANDATORY pre-flight checks)
- **Operating Standards** (mode-specific requirements)
- **Exit Criteria** (task completion checklist)
- **PC2E Integration** (how to apply Predict/Communicate/Explain in this mode)

### [workflows/](workflows/)
**Task-specific procedures for common operations**

Contains:
- **docker-compose-workflow.md** - Creating and managing Docker compose files

### [templates/](templates/)
**Reusable decision records and formats**

Contains:
- **tdr-template.md** - Tech Decision Record format
- **scoring-rubric.md** - Technology evaluation criteria
- **system-log-entry-template.md** - Standardized log format

---

## Core Principles (PC2E)

All work in this workspace follows the **PC2E Framework**:

### **P**redict
- State confidence scores (0-100%) for every hypothesis
- If confidence < 80%, escalate with exact missing context
- Never proceed with limiting choices without presenting alternatives

### **C**ommunicate
- Emit core assumptions before major actions
- Declare tool choices and rationale
- Provide transparency on decision-making process

### **E**xplain
- Document Chain of Reasoning: Observation → Hypothesis → Action
- Explain why rejected alternatives would fail
- Make logic auditable and reproducible

---

## The Four Core Imperatives

Every implementation must satisfy these imperatives (in priority order):

1. **SCALABILITY** (Highest Priority)
   - Can this handle 10x current load without architectural changes?

2. **SECURITY** (Zero-Vulnerability Mandate)
   - Is this secure by default with no known vulnerabilities?

3. **ZERO TECHNICAL DEBT** (0% Target)
   - Is this production-quality from the first commit?

4. **STRICT PRIVACY & DATA MINIMIZATION** (PC2E Mandate)
   - Does this protect PII and minimize data exposure?

---

## Getting Help

- **File structure unclear?** Re-read this README
- **Rule conflict?** Higher precedence wins (Global > Mode > Workflow)
- **Missing a rule?** Check if it belongs in global/, modes/, or workflows/
- **Found a gap?** Document it and update the relevant file

---

## Version History

- **v1.0** (2026-03-19): Initial PC2E-aligned restructure
  - Consolidated 8 folders into 4 (global, modes, workflows, templates)
  - Added PC2E framework integration
  - Standardized all file naming to kebab-case
  - Added exit criteria to all modes
  - Eliminated content duplication via templates
