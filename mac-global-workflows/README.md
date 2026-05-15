# Mac Global Workflows

This directory contains Mac-specific governance workflows and bootstrap configurations
for the PC2E Agent Governance Framework. These workflows are used when running AI agents
directly on macOS (e.g., Claude Desktop, Cursor, or other IDE-integrated agents) rather
than through the NAS Docker stack.

---

## Contents

| File | Purpose |
| --- | --- |
| [00_pc2e_governance_bootstrap.md](00_pc2e_governance_bootstrap.md) | Bootstrap script for loading the full governance context into a Mac-based agent session |
| [globaldockerworkflow.md](globaldockerworkflow.md) | Docker workflow adapted for Mac — supplements the NAS-targeted `workflows/docker-compose-workflow.md` |
| [resolving-errors.md](resolving-errors.md) | Debug mode supplement — error resolution patterns for Mac environment |
| [workflow-docker.md](workflow-docker.md) | Code mode supplement — Docker-specific implementation guidance for Mac |

---

## When to Use These Workflows

Use this directory when your AI agent is running on **macOS** — either locally or
via a remote IDE session connected to the Mac.

Use the root [`workflows/`](../workflows/) directory for NAS/Linux/Docker environments.

---

## Relationship to Parent Framework

These files supplement (not replace) the core governance rules:

```text
Precedence order:
  global/         ← Universal — applies everywhere
  modes/          ← Universal — applies everywhere
  mac-global-workflows/  ← Mac-specific supplements only
  workflows/      ← NAS/Linux-specific supplements only
```

Mac workflow files MUST NOT contradict global or mode rules. If a conflict exists,
the global rule takes precedence and the Mac workflow must be updated.

---

## Cross-References

- [Global Governance](../global/governance-framework.md) — Core imperatives that apply universally
- [Operational Modes](../modes/) — Mode-specific entry/exit gates
- [Docker Compose Workflow](../workflows/docker-compose-workflow.md) — NAS equivalent
- [How to Deploy](../how-to-deploy.md) — Full deployment guide covering both environments
