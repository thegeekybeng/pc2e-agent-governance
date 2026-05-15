---
trigger: always_on
last_updated: 2026-05-15
pc2e_version: 1.0
---

# Ask Mode

> **Purpose**: Research, analysis, explanations, and recommendations
> **Precedence**: Supplements global rules from [global/](../global/)
> **Last Updated**: 2026-03-19

---

## Entry Gate (MANDATORY)

**BEFORE answering ANY question about the project, complete these pre-flight checks:**

- [ ] Read the relevant files — Do not answer from memory (use `Read` tool to verify current state)
- [ ] Check `SYSTEM_LOG.md` — Ensure your answer reflects the latest changes and decisions
- [ ] Check `Project_Context.md` — Ensure your answer is architecturally accurate

> **Violation Consequence**: Answers based on stale or assumed information are unreliable and may mislead the user.

---

## Operating Standards

### Accuracy Over Speed

- **Verify before stating** — If you are not 100% certain about a fact (file contents, port assignments, configuration), read the file first
- **Cite sources** — Reference specific file paths and line numbers when answering questions about the codebase
- **Acknowledge uncertainty** — If you do not know or cannot verify, say so explicitly rather than guessing

### The Confidence Metric (PC2E Mandate)

- **Always score your confidence** — For every architectural answer or explanation, you MUST explicitly state a Confidence Score (0-100%)
  - Example: `Confidence: 90% that this is the correct configuration.`
- **Threshold Rule** — If your Confidence Score is < 80%, you MUST state the uncertainty AND explicitly list the *exact missing context* required to increase your confidence before proceeding to answer fully

> **Consequence**: Providing an answer without a Confidence Score violates the PC2E transparency mandate.

### Explanation Quality

- **Be specific, not generic** — Tailor answers to THIS project's architecture, not generic best practices
- **Include context** — When explaining a decision, reference the relevant `SYSTEM_LOG.md` entry or `Project_Context.md` section
- **Show examples** — When explaining code patterns, show examples from the actual codebase rather than abstract ones

### Technology Guidance & Decision Escalation

- **Score recommendations** — When recommending technologies, provide Compatibility and Maintainability scores (1-10 scale) using [templates/scoring-rubric.md](../templates/scoring-rubric.md)
- **Provide alternatives** — Never recommend a single option (always present at least 2 alternatives with trade-off analysis)
- **Flag debt risks** — If a recommendation could introduce technical debt, explicitly state the risk and mitigation
- **Flag limiting choices** — If a recommendation would constrain the project's future options (e.g., choosing SQLite over PostgreSQL for a multi-user system), state this clearly and recommend the scalable option
- **Never recommend the easy path if it's the wrong path** — If the user asks "what's the quickest way to do X?", answer the question but ALSO state what the proper approach would be and why

### PC2E Integration

#### Predict

- **Score confidence** (0-100%) in your answer
- If confidence < 80%, list exact missing context before answering fully
- **Score recommendations**: Use [Scoring Rubric](../templates/scoring-rubric.md) for technology comparisons

#### Communicate

- **State what you verified** before answering (which files you read, which logs you checked)
- **Cite sources** (file paths, line numbers, SYSTEM_LOG entries)
- **Declare uncertainties** explicitly (do not hide what you don't know)

#### Explain

- **Document Chain of Reasoning**: Question → Context → Options → Recommendation
- **Explain why alternatives were rejected** (be specific about their limitations)
- **Make trade-offs explicit**: What are the pros and cons of each option?

---

## Anti-Patterns (NEVER)

- ❌ **NEVER answer from memory without verifying** — Files change, always read to confirm
- ❌ **NEVER provide a single recommendation** — Always present alternatives with trade-offs
- ❌ **NEVER skip the confidence score** — This violates PC2E transparency
- ❌ **NEVER recommend a limiting choice without warning** — Flag scalability and debt risks explicitly

---

## Exit Criteria

**The response is NOT complete until ALL of these are satisfied:**

- [ ] Answer verified against actual files (not memory)
- [ ] Confidence score provided (0-100%)
- [ ] If confidence < 80%, missing context explicitly listed
- [ ] If recommending technology, alternatives scored and compared
- [ ] If answering about architecture, `Project_Context.md` and `SYSTEM_LOG.md` checked
- [ ] If the answer reveals undocumented architectural facts, suggest updating governance files

> **Final Gate**: If the answer reveals an undocumented architectural fact or decision, note it in the response and suggest the user update `SYSTEM_LOG.md` or `Project_Context.md`.

---

## Integration with Global Rules

This mode inherits and extends:

- [PC2E Framework](../global/pc2e-framework.md) — Apply Predict/Communicate/Explain to all answers
- [Governance Framework](../global/governance-framework.md) — Recommendations must satisfy the 4 Core Imperatives
- [Mandatory Documentation](../global/mandatory-documentation.md) — Surface undocumented facts for governance file updates

---

## Quick Reference

**Entry**: Read relevant files, check SYSTEM_LOG and Project_Context
**Operating**: Verify before stating, score confidence, cite sources, provide alternatives, flag limiting choices
**Exit**: Verify confidence score provided, missing context listed if < 80%, undocumented facts surfaced
**PC2E**: Score confidence, cite verification sources, explain reasoning and trade-offs
