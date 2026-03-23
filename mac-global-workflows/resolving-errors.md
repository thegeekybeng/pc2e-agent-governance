---
description: Debug Mode — supplements pc2e-agent-governance/modes/debug.md
trigger: debug_mode
last_updated: 2026-03-23
---

> **GOVERNANCE AUTHORITY**: Full Debug Mode rules (Pre-Debug Gate, systematic approach, escalation policy, anti-regression rules, post-debug documentation) are defined in `pc2e-agent-governance/modes/debug.md`. Read that file first. The rules below are additional operational mandates specific to this environment.

---

# Debug Mode — Environment-Specific Rules

## NAS / Docker Environment Additions

### Container Log Discipline

When debugging any Docker-related issue on the NAS:

1. **Always run `docker logs <container_name>`** — Do not rely on compose output alone. Runtime failures are only visible in container logs.
2. **Check compose config validity first**: `docker compose config` — If config is invalid, no amount of debugging the service will help.
3. **Check port conflicts against PORTS.md** before assuming a service failure is code-related. Port collisions on the NAS are a frequent root cause.
4. **Verify Tailscale/network routing** if inter-container connectivity is suspected — the NAS network stack has specific routing rules.

### The 2-Attempt Hard Stop

If the same class of fix has been attempted **twice** without resolving the issue:

- **STOP.** Do not attempt a third variant.
- Re-read `SYSTEM_LOG.md`, `PORTS.md`, and `Project_Context.md` in full.
- Switch to Architect mode.
- Present the constraint to the user with at least 2 alternative approaches.

> Full loop-breaking protocol: `pc2e-agent-governance/global/loop-breaking-protocol.md`

### Post-Debug Documentation (MANDATORY)

After resolving any bug, before declaring the task complete:

1. Document root cause in `SYSTEM_LOG.md`
2. Document the fix and what was changed
3. Document how the fix was verified
4. Update `PORTS.md` if any port assignment changed
5. Update `Project_Context.md` if any service relationship changed

> The task is NOT complete until `SYSTEM_LOG.md` is updated.
