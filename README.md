---
trigger: always_on
last_updated: 2026-03-23
pc2e_version: 1.0
---

# PC2E Agent Governance Framework

> Production-ready governance for deterministic AI agents

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Framework Version](https://img.shields.io/badge/version-1.0-blue.svg)](https://github.com/thegeekybeng/pc2e-agent-governance)

[Quick Start](#quick-start) • [Documentation](#documentation) • [Examples](#examples) • [Contributing](#contributing)

---

## Why PC2E?

Enterprise AI adoption is blocked by unpredictable behavior. This framework implements **Predict, Communicate, Explain (PC2E)** principles to ensure:

- **Predictability**: Confidence scores for every technical decision.
- **Transparency**: Core assumptions declared BEFORE major actions are taken.
- **Auditability**: A clear, reproducible chain of reasoning for all system changes.

## Production Results

- ✅ **20+ applications** in production environment.
- ✅ **0 regressions** in 60 days of operations.
- ✅ **100% task completion rate** (all exit criteria strictly met).
- ✅ **Deterministic behavior** across all operating modes.

---

## Quick Start

Integrate the PC2E framework into your AI development workflow in minutes:

### 1. Clone the Framework

Deploy the governance layer directly into your agent's workspace:

```bash
git clone https://github.com/thegeekybeng/pc2e-agent-governance.git .agent
```

### 2. Configure Local Context

Map the `.agent` directory to your AI assistant's context. For VS Code/Cline users, adding the following to your System Prompt ensures mandatory compliance:

> "Prioritize rules in the `.agent/` directory following the hierarchy: Global > Mode > Workflow."

### 3. Verify Operational Gates

Run a test task and verify that the agent emits a **Confidence Score** and **Chain of Reasoning** as mandated by the [PC2E Protocol](#the-pc2e-protocol).

---

## Overview

The **PC2E Agent Governance Framework** is a production-grade orchestration and governance layer designed to ensure predictable, communicative, and verifiable AI agent operations. This framework provides the necessary structure to manage complex multi-agent workflows with zero technical debt and maximum architectural scalability.

## Framework Architecture

The framework is organized into four logical tiers to ensure clear separation of concerns and rule precedence:

1. **Global Governance** ([global/](global/)) - Universal mandates that apply to all operations.
2. **Operational Modes** ([modes/](modes/)) - Context-specific execution standards (Orchestrator, Architect, Code, etc.).
3. **Standardized Workflows** ([workflows/](workflows/)) - Optimized procedures for specific task execution.
4. **Governance Artifacts** ([templates/](templates/)) - Standardized records for decision-making and evaluation.

### Precedence Logic

Rules are applied in descending order of authority: **Global > Mode > Workflow**. In the event of a conflict, the higher-tier rule maintains absolute precedence.

---

## Operational Navigation

### Fundamental Principles

- **PC2E Framework**: Review the [core philosophy](global/pc2e-framework.md) and implementation standards.
- **Operational Imperatives**: Understand the [4 Core Imperatives](global/governance-framework.md) (Scalability, Security, Zero Debt, Privacy).

### Execution Modes

- **Multi-step Planning**: [Orchestrator Mode](modes/orchestrator.md)
- **System Design**: [Architect Mode](modes/architect.md)
- **Implementation**: [Code Mode](modes/code.md)
- **Troubleshooting**: [Debug Mode](modes/debug.md)
- **Research & Analysis**: [Ask Mode](modes/ask.md)

### Specialized Procedures

- **Infrastructure Management**: [Docker Compose Workflow](workflows/docker-compose-workflow.md)
- **Decision Records**: [TDR Template](templates/tdr-template.md)
- **Technology Evaluation**: [Scoring Rubric](templates/scoring-rubric.md)

---

## The PC2E Protocol

Every operation within this framework must strictly adhere to the PC2E protocol:

### Predict

- Quantify confidence levels (0-100%) for all technical hypotheses.
- Proactively identify missing context before execution.
- Present architectural alternatives for limiting choices.

### Communicate

- Declare core assumptions and tool selection rationale explicitly.
- Maintain continuous transparency throughout the execution lifecycle.
- Establish entry gates and pre-flight checklists for every major action.

### Explain

- Maintain an auditable Chain of Reasoning: Observation → Hypothesis → Action.
- Document the rejection criteria for alternative approaches.
- Ensure all logic is reproducible and verifiable via system logs.

---

## Core Operational Imperatives

All implementations are evaluated against these four non-negotiable imperatives, listed in order of priority:

1. **Scalability**: Architect for 10x growth without structural regression.
2. **Security**: Enforce a zero-vulnerability mandate across all layers.
3. **Zero Technical Debt**: Demand production-quality code from the initial commit.
4. **Privacy & Data Minimization**: Protect PII and ensure strict path isolation.

---

## OWASP LLM Top 10 — Framework Compliance

This framework is itself an AI governance layer and is directly exposed to LLM-specific
risks. The table below documents the mitigation status for each OWASP LLM Top 10 category.

| # | Risk | Status | Mitigation |
| --- | --- | --- | --- |
| LLM01 | Prompt Injection | ✅ Mitigated | `global/prompt-injection-defence.md` — 7 defensive layers including system prompt isolation, role separation, and instruction salting |
| LLM02 | Insecure Output Handling | ✅ Mitigated | `templates/output-schema.md` — mode-specific output schemas with required confidence scoring |
| LLM03 | Training Data Poisoning | ➖ N/A | Framework contains no training pipelines; consuming projects must evaluate independently |
| LLM04 | Model Denial of Service | ⚠️ Partial | `global/token-optimisation.md` — context budget management; no explicit DoS rate-limiting at framework layer |
| LLM05 | Supply Chain Vulnerabilities | ✅ Mitigated | `CODEOWNERS` — owner review required on all `global/` changes; `.github/workflows/lint.yml` — automated validation |
| LLM06 | Sensitive Information Disclosure | ✅ Mitigated | `global/privacy-pdpa.md` — Blind Execution Standard, PII masking regex, PDPA controls |
| LLM07 | Insecure Plugin Design | ✅ Mitigated | `CODEOWNERS` — mode files (loaded as plugins) require owner approval before merge |
| LLM08 | Excessive Agency | ✅ Mitigated | HITL gate in `global/governance-framework.md` — unconditional human approval for destructive operations |
| LLM09 | Overreliance | ✅ Mitigated | 80% confidence threshold in `global/pc2e-framework.md` — mandatory escalation below threshold |
| LLM10 | Model Theft | ➖ N/A | Framework governs agent behaviour, not model weights; model protection is infrastructure-layer |

---

## Documentation

Comprehensive documentation for each layer of the framework is located in the following directories:

- **[Global Governance](global/)**: Universal rules, anti-regression patterns, the PC2E core philosophy, and token optimisation.
- **[Operational Modes](modes/)**: Detailed Entry/Exit gates for Orchestrator, Architect, Code, Debug, and Ask modes.
- **[Standardized Workflows](workflows/)**: Step-by-step procedures for Docker, CI/CD, and system migrations.
- **[Governance Artifacts](templates/)**: Standardized formats for Tech Decision Records (TDRs) and system logs.

## Examples

### PC2E in Action: Technical Hypothesis

**Before PC2E:**
> "I will try to fix the database connection by restarting the service."

**After PC2E (High Fidelity):**
> **Predict**: I have 85% confidence that a service restart will resolve the timeout.
> **Communicate**: I am assuming the underlying network config is stable. I will use `systemctl restart` now.
> **Explain**: The logs show a stale socket error (`Err: 110`), which typically indicates a hung process rather than a configuration failure.

## Contributing

We welcome contributions to the PC2E Agent Governance Framework. To propose updates:

1. Identify a gap or inconsistency in the current [Operational Modes](modes/).
2. Document the proposed change using the [TDR Template](templates/tdr-template.md).
3. Submit a Pull Request following the `feat/` or `fix/` [branch naming conventions](global/mandatory-documentation.md).

---

## Support & Maintenance

- **Rule Conflicts**: Refer to the Precedence Logic section.
- **Framework Gaps**: Document detected inconsistencies and propose updates to the relevant module.
- **Version History**: See [CHANGELOG.md](CHANGELOG.md) for detailed change logs.

---

## Release Notes

### v1.0 (2026-03-19)

- Initial deployment of the PC2E-aligned governance structure.
- Consolidation of legacy rule systems into a 4-tier directory hierarchy.
- Standardization of mode-specific entry/exit gates and kebab-case naming.
