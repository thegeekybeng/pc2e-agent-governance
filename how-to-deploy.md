---
trigger: reference
last_updated: 2026-05-15
pc2e_version: 1.0
---

# Deployment Guide — PC2E Agent Governance Framework

> Integrate deterministic, auditable AI governance into your IDE in under 15 minutes.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
1. [Deployment Concepts](#2-deployment-concepts)
1. [Method A — Global IDE Rules](#3-method-a--global-ide-rules)
1. [Method B — Workspace Rules](#4-method-b--workspace-rules)
1. [Method C — Hybrid Deployment (Recommended)](#5-method-c--hybrid-deployment-recommended)
1. [IDE-Specific Instructions](#6-ide-specific-instructions)
1. [Verifying the Deployment](#7-verifying-the-deployment)
1. [Maintaining the Framework](#8-maintaining-the-framework)
1. [Troubleshooting](#9-troubleshooting)

---

## 1. Prerequisites

Before deploying, confirm the following:

| Requirement | Minimum Version | Notes |
|---|---|---|
| Git | 2.30+ | Required to clone and update the framework |
| AI IDE | Any | Cursor, Windsurf, VS Code + Copilot, Antigravity, etc. |
| Global rules support | — | IDE must support user-level or global instruction files |
| Workspace rules support | — | IDE must support per-project instruction files |

> [!NOTE]
> The framework is IDE-agnostic. It is a set of Markdown documents loaded as context
> into any AI assistant. No code is executed. No dependencies are installed.

---

## 2. Deployment Concepts

Understanding the two rule layers is essential before deploying.

### Global Rules

Global rules are loaded by the IDE for **every project and every session**, regardless of which workspace is open. They define the universal baseline behavior of your AI agent.

**Use global rules for:**

- The PC2E pillars (Predict, Communicate, Explain)
- The four core imperatives (Scalability, Security, Zero Debt, Privacy)
- The loop-breaking protocol
- Anti-regression rules
- Mandatory documentation standards

**Storage location:** A user-level config file or directory managed by the IDE (see [Section 6](#6-ide-specific-instructions) for locations per IDE).

### Workspace Rules

Workspace rules are loaded only when the IDE opens a **specific project directory**. They extend or specialize the global rules for that project's context.

**Use workspace rules for:**

- Project-specific architecture context (`Project_Context.md`)
- Port assignments (`PORTS.md`)
- The project's audit trail (`SYSTEM_LOG.md`)
- Project-specific workflows (e.g., custom Docker patterns)
- Mode overrides specific to the project's technology stack

**Storage location:** A config file or directory at the root of the project repository.

### Rule Precedence

When both layers are active, rules are applied in this order:

```text
Global Rules → Workspace Rules → Local Overrides
```

In cases of conflict, the **higher-tier rule takes absolute precedence**. Workspace rules may add specificity but must not contradict global governance mandates.

---

## 3. Method A — Global IDE Rules

This method installs the framework's universal governance layer so it applies to every project you work on.

### Step 1: Clone the Framework

Clone the repository to a stable, permanent location on your machine. Do not clone it inside a project directory.

```bash
# Recommended locations
# macOS / Linux
git clone https://github.com/thegeekybeng/pc2e-agent-governance.git ~/.agent-governance

# Windows
git clone https://github.com/thegeekybeng/pc2e-agent-governance.git %USERPROFILE%\.agent-governance
```

### Step 2: Identify Your IDE's Global Rules File

Each IDE has a specific file or directory for global AI instructions. See [Section 6](#6-ide-specific-instructions) for the exact path for your IDE.

### Step 3: Reference the Framework Files

In your IDE's global rules file, add the following instruction block. Adjust the path to match where you cloned the framework in Step 1.

```markdown
# PC2E Agent Governance Framework

Apply the following governance rules to all sessions. Rules are loaded in order
of precedence: Global > Mode > Workflow.

## Core Governance (Always Active)

Read and apply these files before beginning any task:
- ~/.agent-governance/global/governance-framework.md
- ~/.agent-governance/global/pc2e-framework.md
- ~/.agent-governance/global/anti-regression-rules.md
- ~/.agent-governance/global/loop-breaking-protocol.md
- ~/.agent-governance/global/mandatory-documentation.md

## Operational Modes

Apply the relevant mode file based on the current task type:
- Orchestration / planning: ~/.agent-governance/modes/orchestrator.md
- Architecture / design: ~/.agent-governance/modes/architect.md
- Implementation / coding: ~/.agent-governance/modes/code.md
- Debugging / diagnosis: ~/.agent-governance/modes/debug.md
- Research / analysis: ~/.agent-governance/modes/ask.md

## Precedence Rule

Global > Mode > Workflow. In any conflict, the higher-tier rule wins.
```

> [!IMPORTANT]
> Use **absolute paths** in global rules. Relative paths will resolve incorrectly
> when the IDE opens projects in different directories.

### Step 4: Reload the IDE

Close and reopen the IDE (or trigger a context reload if your IDE supports it) to activate the new global rules.

---

## 4. Method B — Workspace Rules

This method installs the framework on a per-project basis without touching global settings. Use this when you want to govern a specific repository without affecting other projects.

### Step 1: Clone the Framework into the Project

Add the framework as a subdirectory within the project repository. The `.agent` convention keeps it clearly scoped and separate from application code.

```bash
# From the root of your project repository
git clone https://github.com/thegeekybeng/pc2e-agent-governance.git .agent
```

Add `.agent` to your `.gitignore` if you do not want to commit the governance layer to the project repository:

```bash
echo ".agent/" >> .gitignore
```

Alternatively, to commit the governance layer as a tracked submodule:

```bash
git submodule add https://github.com/thegeekybeng/pc2e-agent-governance.git .agent
git submodule update --init
```

### Step 2: Create the Workspace Rules File

Create the IDE's workspace rules file at the project root. See [Section 6](#6-ide-specific-instructions) for the exact filename per IDE.

### Step 3: Populate the Workspace Rules File

```markdown
# Project Governance — PC2E Framework

## Governance Layer

Apply the following rules for all work in this project:
- .agent/global/governance-framework.md
- .agent/global/pc2e-framework.md
- .agent/global/anti-regression-rules.md
- .agent/global/loop-breaking-protocol.md
- .agent/global/mandatory-documentation.md

## Project Context (Read at Session Start)

Before any work begins, read:
- PORTS.md — Authoritative port ledger
- Project_Context.md — Service architecture map
- SYSTEM_LOG.md — Audit trail of all changes

## Mode Selection

Select the mode file that matches the current task:
- .agent/modes/orchestrator.md (planning)
- .agent/modes/architect.md (design)
- .agent/modes/code.md (implementation)
- .agent/modes/debug.md (debugging)
- .agent/modes/ask.md (research)

## Precedence

Global > Mode > Workflow. Workspace rules extend global rules; they do not override them.
```

### Step 4: Initialize Project Governance Files

If they do not already exist, create the three mandatory governance files at the project root:

```bash
# Create PORTS.md
cat > PORTS.md << 'EOF'
# Port Assignments

| Port | Service | Purpose | Status |
|------|---------|---------|--------|
| — | — | No ports assigned yet | — |
EOF

# Create Project_Context.md
cat > Project_Context.md << 'EOF'
# Project Context

## Service Inventory
*Document services here*

## Service Relationships
*Document dependencies here*

## Architecture Notes
*Document architecture decisions here*
EOF

# Create SYSTEM_LOG.md
cat > SYSTEM_LOG.md << 'EOF'
# System Log

> Audit trail of all technical decisions. Update after every session.

---

## Template Entry

**Date (UTC):** YYYY-MM-DD HH:MM
**Summary:** What was done
**Affected Files:** List of files changed
**Chain of Reasoning:** Observation → Hypothesis → Action
**Verification:** How the change was confirmed working
**Confidence:** XX%
EOF
```

---

## 5. Method C — Hybrid Deployment (Recommended)

The hybrid approach places universal governance in global rules and project-specific context in workspace rules. This is the production configuration used in the PC2E environment.

### Architecture

```text
Global Rules (applies everywhere)
└── governance-framework.md    ← 4 Core Imperatives
└── pc2e-framework.md          ← Predict / Communicate / Explain
└── anti-regression-rules.md   ← Prevent regressions
└── loop-breaking-protocol.md  ← Escape stuck states
└── mandatory-documentation.md ← Documentation standards

Workspace Rules (per project)
└── Project_Context.md         ← Service map for this project
└── PORTS.md                   ← Port ledger for this project
└── SYSTEM_LOG.md              ← Audit trail for this project
└── .agent/modes/<mode>.md     ← Mode file for current task type
```

### Implementation

**Global rules file** — reference the cloned framework's `global/` and `modes/` directories using absolute paths (follow Method A, Steps 1–3).

**Workspace rules file** — reference only project-specific context using relative paths (follow Method B, Steps 2–4), omitting the global files already covered by global rules.

Workspace rules example for hybrid mode:

```markdown
# Project Governance (Workspace Layer)

## Project Context — Read at Session Start

- PORTS.md
- Project_Context.md
- SYSTEM_LOG.md

## Workflows Active in This Project

- .agent/workflows/docker-compose-workflow.md

## Mode Override (if different from global default)

Current task mode: .agent/modes/code.md
```

---

## 6. IDE-Specific Instructions

### Cursor

| Layer | File Location |
|---|---|
| Global rules | `~/.cursor/rules` (directory) or `~/.cursorrules` (single file) |
| Workspace rules | `.cursorrules` at the project root |

Create a global rules directory and add one file per governance document, or concatenate all global files into a single `.cursorrules` file.

```bash
# Option 1: Single global file (simpler)
cat ~/.agent-governance/global/*.md > ~/.cursorrules

# Option 2: Per-file directory (easier to update)
mkdir -p ~/.cursor/rules
cp ~/.agent-governance/global/*.md ~/.cursor/rules/
```

For workspace rules, create `.cursorrules` at the project root and populate it per Method B or C.

---

### Windsurf

| Layer | File Location |
|---|---|
| Global rules | `~/.windsurfrules` |
| Workspace rules | `.windsurfrules` at the project root |

```bash
# Global rules
cat ~/.agent-governance/global/*.md > ~/.windsurfrules

# Workspace rules (per project)
touch .windsurfrules  # then populate per Method B or C
```

---

### VS Code + GitHub Copilot / Copilot Chat

| Layer | File Location |
|---|---|
| Global instructions | `~/.vscode/copilot-instructions.md` (if supported) or User Settings → `github.copilot.chat.codeGeneration.instructions` |
| Workspace instructions | `.github/copilot-instructions.md` at the project root |

```bash
# Workspace instructions
mkdir -p .github
touch .github/copilot-instructions.md  # populate per Method B
```

For global settings, open VS Code Settings (JSON) and add:

```json
"github.copilot.chat.codeGeneration.instructions": [
  {
    "file": "/absolute/path/to/.agent-governance/global/governance-framework.md"
  },
  {
    "file": "/absolute/path/to/.agent-governance/global/pc2e-framework.md"
  }
]
```

---

### Antigravity (Google)

| Layer | File Location |
|---|---|
| Global rules | `~/.gemini/GEMINI.md` |
| Workspace rules | `GEMINI.md` at the project root, or `.claude/CLAUDE.md` |

```bash
# Append to global rules
cat ~/.agent-governance/global/governance-framework.md >> ~/.gemini/GEMINI.md
cat ~/.agent-governance/global/pc2e-framework.md >> ~/.gemini/GEMINI.md

# Workspace rules
touch GEMINI.md  # populate per Method B
```

---

### Claude Code (Anthropic)

| Layer | File Location |
|---|---|
| Global rules | `~/.claude/CLAUDE.md` |
| Workspace rules | `CLAUDE.md` at the project root |

```bash
# Global rules
mkdir -p ~/.claude
cat ~/.agent-governance/global/*.md >> ~/.claude/CLAUDE.md

# Workspace rules
touch CLAUDE.md  # populate per Method B
```

---

## 7. Verifying the Deployment

After deploying, issue the following test prompt to your AI agent:

```text
What governance framework are you operating under?
List the four core imperatives in priority order.
What is your confidence threshold for mandatory escalation?
```

**Expected response characteristics:**

- Names the PC2E framework explicitly
- Lists: Scalability → Security → Zero Technical Debt → Privacy
- States the 80% confidence escalation threshold
- References specific file paths from the governance layer
- Emits a confidence score as part of the response

**If the agent does not respond with the above**, the governance files have not been loaded. Re-check:

1. File paths in your rules file are correct and accessible
1. The IDE has been reloaded after configuration
1. The rules file is in the correct location for your IDE (see [Section 6](#6-ide-specific-instructions))

---

## 8. Maintaining the Framework

### Updating to the Latest Version

Pull updates from the upstream repository:

```bash
# If installed as a direct clone
cd ~/.agent-governance && git pull origin main

# If installed as a submodule inside a project
git submodule update --remote .agent
```

Review the [CHANGELOG.md](CHANGELOG.md) after every update to understand what changed before reloading your IDE.

### Customizing the Framework

Do not modify files inside the cloned framework directory. Instead, extend behavior via your workspace rules file. This preserves your ability to pull upstream updates without merge conflicts.

**To add a project-specific rule:**

Add it to your workspace rules file, not to the framework files:

```markdown
## Project-Specific Extension

In addition to the global governance mandates, apply the following rule for this project:
- All API responses must include a `request_id` field for traceability.
```

### Version Pinning

For production environments where stability is critical, pin to a specific commit rather than tracking `main`:

```bash
cd ~/.agent-governance
git checkout <commit-hash>
```

Document the pinned version in your `SYSTEM_LOG.md`.

---

## 9. Troubleshooting

### Agent ignores governance rules

**Cause:** Rules file not found or not loaded by the IDE.

**Resolution:**

1. Verify the file path is correct for your IDE (see [Section 6](#6-ide-specific-instructions))
1. Confirm the file has read permissions: `ls -la ~/.cursorrules`
1. Restart the IDE completely (not just the window)
1. Start a new conversation — some IDEs do not reload rules mid-session

---

### Agent applies rules inconsistently

**Cause:** Context window overflow. The governance files exceed what the IDE loads per session.

#### Context-Window Budget — Tiered Loading Strategy

Use this table to decide what to load based on your agent's context window size:

| Tier | Context Window | Load These Files | Skip |
| --- | --- | --- | --- |
| **Tier 1 — Minimal** | < 16K tokens | `governance-framework.md`, `pc2e-framework.md`, `loop-breaking-protocol.md` | All mode files, anti-regression, documentation |
| **Tier 2 — Standard** | 16K–32K tokens | Tier 1 + `anti-regression-rules.md` + active mode file only | Inactive modes, `mandatory-documentation.md` |
| **Tier 3 — Full** | 32K–128K tokens | All `global/` files + active mode + project context | Inactive modes |
| **Tier 4 — Optimal** | 128K+ tokens | All governance files + all modes + full project context | Nothing |

**Approximate token cost per file** (uncompressed):

| File | Approx. Tokens |
| --- | --- |
| `governance-framework.md` | ~3,500 |
| `pc2e-framework.md` | ~2,800 |
| `loop-breaking-protocol.md` | ~2,000 |
| `anti-regression-rules.md` | ~3,200 |
| `mandatory-documentation.md` | ~3,000 |
| `prompt-injection-defence.md` | ~2,500 |
| `privacy-pdpa.md` | ~2,800 |
| `token-optimisation.md` | ~2,200 |
| Any single mode file | ~2,000–3,000 |
| **Total (all global + all modes)** | **~35,000** |

**Resolution:**

1. Use the hybrid deployment (Method C) — put only project context in workspace rules
1. Apply prompt caching at the governance block boundary (see `global/token-optimisation.md`)
1. For Tier 1/2 contexts, load mode files inline at task start rather than globally:

```markdown
## Task Context
Current mode: [paste contents of modes/code.md here]
```

1. Use hierarchical references: reference file paths without embedding content
   when your IDE supports on-demand file loading

---

### Workspace rules conflict with global rules

**Cause:** Workspace rules contradict rather than extend global rules.

**Resolution:**
Review the workspace rules file and ensure it only adds project-specific context. Remove any statement that contradicts a global mandate (e.g., removing the 80% confidence threshold). The precedence rule is: **Global > Workspace. Global rules are non-negotiable.**

---

### Framework files not found after update

**Cause:** File was renamed or moved in a framework update.

**Resolution:**

1. Run `git -C ~/.agent-governance log --oneline -5` to see recent changes
1. Run `git -C ~/.agent-governance diff HEAD~1 --name-only` to see renamed files
1. Update your rules file paths accordingly
1. Log the path change in `SYSTEM_LOG.md`

---

## Summary

| Deployment Method | Best For |
|---|---|
| **A — Global only** | Solo developers, consistent behavior across all projects |
| **B — Workspace only** | Team projects, governance scoped to a specific repository |
| **C — Hybrid (Recommended)** | Production environments, maximum coverage with minimal redundancy |

The hybrid method (C) is the production configuration. Global rules enforce universal standards; workspace rules provide project-specific context. Together they ensure the AI agent operates under full PC2E governance from the first token of every session.

---

*For framework architecture details, see [README.md](README.md).
For the audit trail format, see [templates/system-log-entry-template.md](templates/system-log-entry-template.md).
For version history, see [CHANGELOG.md](CHANGELOG.md).*
