---
description: Code Mode — supplements pc2e-agent-governance/modes/code.md and global/governance-framework.md
trigger: code_mode
last_updated: 2026-03-23
pc2e_version: 1.0
---

# Workflow Docker

> **GOVERNANCE AUTHORITY**: Full Code Mode rules (pre-implementation gate, decision escalation, code quality standards, security audit, zero technical debt policy, post-code verification) are defined in `pc2e-agent-governance/modes/code.md` and `pc2e-agent-governance/global/governance-framework.md`. Read those files first. The standards below are environment-specific extensions.

---

## Code Mode — Environment-Specific Standards

## NAS / Docker Environment Extensions

### Pre-Implementation Checklist (NAS-Specific Additions)

Before writing or modifying any code in this environment:

- [ ] Read `PORTS.md` — verify no port collision exists for any new service
- [ ] Read `Project_Context.md` — confirm the service relationship map is current
- [ ] Read `SYSTEM_LOG.md` — confirm this approach has not previously failed
- [ ] For Docker changes: run `docker compose config` on the target file to validate syntax before applying

### Technology Decision Record (TDR) Requirement

When introducing ANY new technology, library, or framework:

1. Document using the TDR format in `SYSTEM_LOG.md`
2. Use the standard template: `pc2e-agent-governance/templates/tdr-template.md`
3. Use the scoring rubric: `pc2e-agent-governance/templates/scoring-rubric.md`
4. **Threshold**: Do NOT use any technology scoring below 5/10 on compatibility OR maintainability without explicit user approval

### Docker-Specific Code Standards

- **Non-root execution**: Every `Dockerfile` MUST include a `USER` directive with a non-root user
- **Multi-stage builds**: Production `Dockerfile`s MUST use multi-stage builds
- **Health checks**: Every service in `docker-compose.yml` MUST include a `healthcheck` section
- **Pin versions**: Use specific version tags for base images — NEVER `latest`
- **Secrets**: All credentials go in `.env` files — NEVER in `docker-compose.yml` or source code

### Post-Code Verification (MANDATORY)

After making changes, before declaring the task complete:

1. Validate syntax — run linters, type checkers, or `docker compose config` as appropriate
2. Test the change — run a command that verifies the change works; read every line of output
3. Check for regressions — verify existing functionality is unaffected
4. Update `SYSTEM_LOG.md` — timestamped entry with summary, affected files, and rationale
5. Update `PORTS.md` — if any port assignment changed
6. Update `Project_Context.md` — if any service relationship changed

> The task is NOT complete until documentation is updated.
