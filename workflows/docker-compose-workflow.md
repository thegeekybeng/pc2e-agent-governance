---
trigger: always_on
last_updated: 2026-05-15
pc2e_version: 1.0
---

# Docker Compose Workflow

> **Purpose**: Creating and managing Docker Compose files for containerized services
> **Precedence**: Supplements global and mode-specific rules
> **Last Updated**: 2026-03-19

---

## Pre-Flight Checks (MANDATORY)

**BEFORE creating or modifying ANY docker-compose.yml file:**

- [ ] Read `Project_Context.md` — Understand the folder structure and connective parts within the project
- [ ] Read ALL relevant project files — Understand the codebase before containerizing it
- [ ] Read `PORTS.md` — Verify port availability and document new port allocations
- [ ] Read `SYSTEM_LOG.md` — Check for past Docker-related decisions or failures
- [ ] Understand user intent — If instructions are unclear, CLARIFY before proceeding

> **Anti-Pattern**: Do NOT give one-liner replies and expect the user to understand. Your interpretation and a human's interpretation can be very different.

---

## Docker Compose Standards

### File Creation Standards

- **New files, not modifications**: When asked to create a new `docker-compose.yml` file, always create a NEW file (do not modify existing unless explicitly requested)
- **Header timestamp**: Every `docker-compose.yml` file MUST include a hash, date, and timestamp at the top for record-keeping

  ```yaml
  # docker-compose.yml
  # Created: 2026-03-19 20:30:00
  # Hash: <git-commit-hash or unique-id>
  ```

### Security Standards (Core Imperative #2)

- **Non-root containers**: Every service MUST run as a non-root user
- **No hardcoded secrets**: Use environment variables or `.env` files (never commit secrets to version control)
- **Security headers**: Web-facing services MUST be fronted by Nginx with proper security headers
- **Network isolation**: Use Docker networks to isolate services

### Scalability Standards (Core Imperative #1)

- **Stateless services**: Services should be designed to run multiple replicas
- **External state stores**: Use Redis, PostgreSQL, or other external stores for persistent state
- **Health checks**: Every service SHOULD include a `healthcheck` directive

### Quality Standards (Core Imperative #3)

- **Pin versions**: ALWAYS use specific version tags for images (e.g., `node:20-alpine`, NOT `node:latest`)
- **Restart policies**: Use `restart: unless-stopped` for production services
- **Resource limits**: Define memory and CPU limits for production services
- **Volume management**: Use named volumes for persistent data

---

## Workflow Steps

### Step 1: Pre-Flight Context Gathering

1. Read `Project_Context.md` to understand the ecosystem
1. Read all project files to understand the codebase
1. Read `PORTS.md` to know available ports
1. Read `SYSTEM_LOG.md` for past decisions

### Step 2: Clarification (If Needed)

- If user instructions are unclear, STOP and ASK for clarification
- Do NOT proceed with assumptions that could be wrong

### Step 3: Create and Validate

- Create the compose file with proper header timestamp
- Run `docker compose config` to validate syntax
- Read the output to verify configuration

### Step 4: Testing (MANDATORY)

- **Sandboxed testing**: Test before declaring success
- Run `docker compose up -d` and verify services start
- Check `docker logs <service>` for each service
- **Read terminal output**: Monitor output yourself, not the user

### Step 5: Documentation

- Update `PORTS.md` with new port allocations
- Update `Project_Context.md` with new services
- Update `SYSTEM_LOG.md` with timestamp, decisions, and rationale

---

## Anti-Patterns (NEVER)

- ❌ **NEVER skip reading the terminal output**
- ❌ **NEVER use `latest` tags**
- ❌ **NEVER assume the file works without testing**
- ❌ **NEVER skip clarification when instructions are unclear**

---

## Exit Criteria

- [ ] File created with header timestamp
- [ ] Syntax validated with `docker compose config`
- [ ] Services tested and verified
- [ ] All governance files updated

---

## Integration with Global Rules

This workflow inherits:

- [PC2E Framework](../global/pc2e-framework.md)
- [Governance Framework](../global/governance-framework.md)
- [Mandatory Documentation](../global/mandatory-documentation.md)
