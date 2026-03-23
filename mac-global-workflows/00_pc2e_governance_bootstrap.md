---
description: PC2E Governance Bootstrap — Session Zero. Read this FIRST before any other file or action.
trigger: always_on
priority: CRITICAL
pc2e_version: 1.0
last_updated: 2026-03-23
---

# PC2E Governance Bootstrap

> **THIS FILE IS READ FIRST. EVERY SESSION. NO EXCEPTIONS.**

---

## 1. Governance Framework Location

The authoritative PC2E governance framework is located in the **`pc2e-agent-governance`** workspace folder.

This folder was previously named `.agent`. It is now permanently named `pc2e-agent-governance`.

**Do NOT look for a `.agent` folder. It does not exist. Always use `pc2e-agent-governance`.**

---

## 2. Mandatory Session Startup Protocol

Before responding to any task, instruction, or question — **STOP and complete this intake sequence**:

| # | File to Read | Location | Purpose |
|---|---|---|---|
| 1 | `pc2e-framework.md` | `pc2e-agent-governance/global/` | Core PC2E philosophy — Predict, Communicate, Explain |
| 2 | `governance-framework.md` | `pc2e-agent-governance/global/` | The 4 Core Imperatives and all development standards |
| 3 | `PORTS.md` | Project root | Authoritative port assignment ledger |
| 4 | `Project_Context.md` | Project root | Service architecture and relationship map |
| 5 | `SYSTEM_LOG.md` | Project root | Audit trail — check before every implementation |

> Files 3–5 are project-specific. If they do not exist in the current workspace, note their absence and continue.

---

## 3. Governance Precedence Hierarchy

Rules are applied in this strict order of authority:

```
pc2e-agent-governance/global/  ← HIGHEST AUTHORITY
         ↓
pc2e-agent-governance/modes/
         ↓
pc2e-agent-governance/workflows/
         ↓
global_workflows/ (this folder)  ← Supplements; never overrides governance
         ↓
Workspace-specific .gemini/ files  ← Lowest authority
```

**In any conflict, the higher tier wins absolutely.**

---

## 4. Operational Mode Selection

Before beginning any task, identify and declare the operational mode:

| Mode | Use When | File |
|---|---|---|
| **Orchestrator** | Multi-step planning, task decomposition, directing sub-agents | `pc2e-agent-governance/modes/orchestrator.md` |
| **Architect** | System design, technology selection, infrastructure planning | `pc2e-agent-governance/modes/architect.md` |
| **Code** | Writing, modifying, or refactoring code | `pc2e-agent-governance/modes/code.md` |
| **Debug** | Diagnosing and resolving errors or failures | `pc2e-agent-governance/modes/debug.md` |
| **Ask** | Research, analysis, explanation, no implementation | `pc2e-agent-governance/modes/ask.md` |

Read the corresponding mode file before beginning the task.

---

## 5. PC2E Core Protocol (Always Active)

Every response that involves a significant action MUST include:

### Predict
State your confidence score before acting:
- **≥ 80%** → May proceed
- **< 80%** → STOP. State what context is missing. Present 2+ alternatives. Wait for direction.

### Communicate
Before major actions, declare:
- Core assumptions
- Tool/technology choice and why
- What could break

### Explain
After every decision, document:
- **Observation** → what was detected
- **Hypothesis** → root cause or best approach
- **Action** → specific change made

---

## 6. Non-Negotiable Imperatives (Summary)

Full detail in `pc2e-agent-governance/global/governance-framework.md`. In brief:

1. **Scalability** — Every design must handle 10x load. Stateless services. No single points of failure.
2. **Security** — Zero-vulnerability mandate. No hardcoded secrets. Non-root Docker containers. Audit all inputs.
3. **Zero Technical Debt** — Production-quality from commit one. No TODO without SYSTEM_LOG.md entry.
4. **Privacy** — Never log PII. Treat sensitive data as ephemeral. Blind execution standard.

---

## 7. Loop-Breaking Protocol

If the same class of fix has been attempted **twice without success**:

1. **STOP immediately** — Do not attempt a third variant of the same approach
2. **Re-read** `SYSTEM_LOG.md`, `PORTS.md`, `Project_Context.md`
3. **Switch mode** — Move from Code/Debug to Architect mode
4. **Escalate** — Present the constraint to the user with 2+ alternative architectural approaches

Full protocol: `pc2e-agent-governance/global/loop-breaking-protocol.md`

---

## 8. Device Context & Execution Environment

This governance configuration is deployed on two devices with **different execution environments**:

| Device | Governance Path | Global Workflows Path |
|---|---|---|
| **Ugreen NAS** | `/volume2/docker/pc2e-agent-governance/` | `/home/thegeekybeng/.gemini/antigravity/global_workflows/` |
| **MacBook Air** | `~/pc2e-agent-governance/` | `~/.gemini/antigravity/global_workflows/` |

### Identify Your Current Device

Check the active workspace path:
- Starts with `/volume2/` → **Ugreen NAS**
- Starts with `/Users/` → **MacBook Air**

### MacBook Air Execution Rules

You are on the **MacBook Air**. Node.js, npm, npx, Python, pip, and other runtimes are installed natively.

Run commands directly — no Docker wrapper required:

```bash
# ✅ Native execution on MacBook Air
npm install
npm run build
npx <command>
node script.js
python3 script.py
pip3 install <package>
```

### NAS Execution Rules — Do NOT Apply Here

The NAS requires all npm/npx/node/pip and other runtime commands to run via `docker run`.
That rule is documented in `nas-execution-rules.md` which exists **only in the NAS global_workflows folder**.

**Do not apply NAS Docker-wrapping rules on this MacBook Air.**
