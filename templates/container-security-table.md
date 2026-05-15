---
trigger: reference
last_updated: 2026-05-15
pc2e_version: 1.0
---

# Container Security Standards Table

> This table MUST be adopted by every project governed by the PC2E framework.
> Copy it into your project's `SECURITY_FRAMEWORK.md` and populate the Status column
> for each service in your stack.

---

## How to Use

1. Copy the table below into your project's `SECURITY_FRAMEWORK.md`
2. Add a column for each service/container in your stack
3. Mark each cell as ✅ (implemented), ⚠️ (partial), ❌ (not implemented), or ➖ N/A
4. All ❌ cells are blocking issues before the container ships to production

---

## Container Security Standards

| Control | Requirement | [Service 1] | [Service 2] | [Service 3] |
| --- | --- | --- | --- | --- |
| Non-root execution | `USER` directive in Dockerfile — container MUST NOT run as root | | | |
| Multi-stage build | Production image MUST use multi-stage build — no build tools in final image | | | |
| Pinned base image | Base image MUST use exact digest or version tag — no `latest` | | | |
| Health check | `HEALTHCHECK` defined in Dockerfile or `healthcheck:` in compose | | | |
| Read-only filesystem | `read_only: true` in compose where possible; explicit volume mounts for writable paths | | | |
| No privileged mode | `privileged: false` — never use `--privileged` in production | | | |
| Resource limits | `mem_limit`, `cpus` defined in compose to prevent resource exhaustion | | | |
| Secrets via env vars | No secrets in Dockerfile `ENV` or image layers — use `.env` files or secret stores | | | |

---

## Additional Controls (Evaluate per Service)

| Control | Requirement | Notes |
| --- | --- | --- |
| Network isolation | Service joins only required Docker networks — no blanket `host` mode | |
| Port exposure | Only required ports exposed to host — internal services bind to internal networks only | |
| Log driver | Structured logging configured — avoid default JSON file driver for production | |
| Image scan | Container image scanned with Trivy or equivalent before production push | |
| Socket proxy | If Docker socket access is needed, use a socket proxy — never mount `/var/run/docker.sock` directly in production | |

---

## Verification Commands

Run these after every container change:

```bash
# Verify non-root execution
docker inspect <container> --format '{{.Config.User}}'
# Expected: non-empty string (e.g., "node", "1001")

# Check for privileged mode
docker inspect <container> --format '{{.HostConfig.Privileged}}'
# Expected: false

# Verify resource limits
docker inspect <container> --format '{{.HostConfig.Memory}} {{.HostConfig.NanoCPUs}}'
# Expected: non-zero values

# Check health check status
docker inspect <container> --format '{{.State.Health.Status}}'
# Expected: healthy

# Verify no latest tags in compose
grep "image:" docker-compose*.yml | grep ":latest"
# Expected: no output
```

---

## Reference

- `global/governance-framework.md` — Core Imperative 2 (Security): non-root, multi-stage mandates
- `modes/code.md` — Docker Security Standards
- `AGENTS.md` — Service-specific port and container reference
- OWASP Docker Security Cheat Sheet: <https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html>
