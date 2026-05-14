---
trigger: always_on
last_updated: 2026-03-23
pc2e_version: 1.0
---

# Code Mode

> **Purpose**: Implementation, file creation, and code modification
> **Precedence**: Supplements global rules from [global/](../global/)
> **Last Updated**: 2026-03-19

---

## Entry Gate (MANDATORY)

**BEFORE writing or modifying ANY code, complete these pre-flight checks:**

- [ ] Read the target file(s) — Use `Read` tool to understand current state (NEVER assume file contents from memory)
- [ ] Read `SYSTEM_LOG.md` — Verify the proposed approach has not already been tried and failed
- [ ] Read `PORTS.md` — If ANY networking change is involved, verify port availability
- [ ] Identify the impact zone — List every file that will be directly or indirectly affected by this change
- [ ] State your plan — Before making changes, briefly describe: what will change, why, and what could break

> **Violation Consequence**: Skipping this gate makes the implementation unreliable and may cause regressions.

---

## Operating Standards

### Decision Escalation Check (PC2E: Predict - BEFORE Every Implementation)

**STOP and ask yourself**: Is this the BEST approach, or am I making a limiting choice?

If you are about to:

- Use in-memory storage when Redis/database could be used
- Use a hardcoded value instead of a configurable one
- Skip pagination, auth, or error handling
- Add a dependency scoring below 7/10 compatibility or maintainability
- Implement a workaround instead of a proper fix

**Then STOP. State the limitation. Present 2+ alternatives. Wait for user approval.**

**Explainability Standard (PC2E Mandate):** When presenting alternatives, you MUST explain EXACTLY why the rejected alternatives would fail at scale or introduce debt, rather than merely stating they weren't chosen.

> **Consequence**: Implementing a limiting choice without escalating = mandatory rework.

### File Discipline

- **Read before edit**: ALWAYS use `Read` tool on a file before modifying it (never modify based on assumptions)
- **Minimal changes**: Make the smallest change that solves the problem (do not refactor unrelated code unless explicitly asked)
- **No orphaned files**: Every file you create MUST be imported, referenced, or documented somewhere (verify it has at least one reference)

### Docker Standards (Core Imperative #2: Security)

- **Non-root execution**: Every `Dockerfile` MUST include a `USER` directive with a non-root user
- **Multi-stage builds**: Production `Dockerfile`s MUST use multi-stage builds
- **Health checks**: Every service in `docker-compose.yml` SHOULD include a `healthcheck` section
- **Pin versions**: Use specific version tags for base images (e.g., `node:20-alpine`, NOT `node:latest`)

### Dependency Management (Core Imperative #3: Zero Technical Debt)

- **Pin versions**: Always specify exact versions in `package.json`, `requirements.txt`, etc.
- **Document new dependencies**: For every new dependency added, include a comment or log entry explaining what it does and why it's needed
- **Prefer lightweight alternatives**: Choose the smallest library that solves the problem (avoid kitchen-sink frameworks)

### Error Handling

- **No silent failures**: Every `catch` block, every error handler MUST log or surface the error with context
- **Meaningful error messages**: Include what operation failed, what input caused it, and what the user should do about it
- **Graceful degradation**: Services MUST handle dependency failures gracefully (e.g., if database is down, report it rather than crashing)

### Scalability Standards (Core Imperative #1)

- **Stateless by default**: Services MUST NOT store session state in memory (use external stores: Redis, database)
- **Connection pooling**: Database connections MUST use connection pools with configurable limits
- **Async operations**: Long-running operations MUST be asynchronous (queues, workers) — never block the request thread
- **Pagination**: All list endpoints MUST support pagination (never return unbounded result sets)
- **Indexing**: Every database query used in production MUST have appropriate indexes (document index decisions in comments)

### Security Standards (Core Imperative #2: Zero-Vulnerability Mandate)

- **Input validation**: ALL user inputs MUST be validated and sanitized before processing
  - Use parameterized queries for SQL
  - Escape HTML output to prevent XSS
- **Authentication**: Every API endpoint MUST require authentication unless explicitly designated as public
- **Authorization**: Every endpoint MUST verify the caller has permission for the requested operation
- **Secrets management**: NEVER hardcode secrets, API keys, or credentials in code (use environment variables or secret stores)
- **Dependency audit**: After adding or updating dependencies, run `npm audit` / `pip audit` and resolve any HIGH or CRITICAL vulnerabilities before proceeding
- **CORS policy**: Production CORS configurations MUST use specific origins — NEVER use wildcard `*`
- **Security headers**: All web-facing services MUST set:
  - `Content-Security-Policy`
  - `X-Frame-Options: DENY`
  - `X-Content-Type-Options: nosniff`
  - `Strict-Transport-Security`

### Zero Technical Debt Standards (Core Imperative #3)

- **No TODO/FIXME without tracking**: Every TODO or FIXME comment MUST have a matching entry in `SYSTEM_LOG.md` with a resolution timeline
- **No dead code**: Remove unused imports, variables, functions, and commented-out blocks
- **No magic numbers**: Use named constants or configuration values for all numeric literals
- **No copy-paste**: If code is duplicated more than once, refactor into a shared utility function
- **Type safety**: Use TypeScript strict mode for JS projects and type hints for Python projects
- **Function size limit**: No function longer than 50 lines (refactor into smaller, testable units)
- **Explainability over Cleverness (PC2E)**: Code comments MUST explain the *business logic or architectural reason* behind a block of code ("Why"), not just what the code technically executes ("What")

### Technology Documentation Requirement

**When introducing ANY new technology, library, or framework, you MUST produce a Tech Decision Record (TDR) using [templates/tdr-template.md](../templates/tdr-template.md) and include it in `SYSTEM_LOG.md`.**

> Do NOT use any technology scoring below 5 on either metric without explicit user approval.

### PC2E Integration

#### Predict
- **State confidence** (0-100%) in your implementation approach
- If confidence < 80%, escalate with exact missing context
- **Identify risk zones**: Which parts of this implementation are most likely to break?

#### Communicate
- **Emit core assumptions** before major code changes
- **Declare tool/library choices** and rationale
- **State the impact zone**: Which files and services will be affected?

#### Explain
- **Document Chain of Reasoning**: Problem → Constraint → Options → Implementation Choice
- **Explain why rejected alternatives would fail** (be specific about failure modes)
- **Code comments explain "Why"**: Business logic and architectural reasons, not just "What"

---

## Anti-Patterns (NEVER)

- ❌ **NEVER modify a file without reading it first** — even if you "know" what's in it from earlier
- ❌ **NEVER skip validation or error handling** to "ship faster" — these are not optional
- ❌ **NEVER use `latest` tags** in Docker images — this creates non-reproducible builds
- ❌ **NEVER hardcode secrets** — use environment variables or secret stores
- ❌ **NEVER implement a workaround without escalating** — fix the root cause or document why temporary is acceptable

---

## Exit Criteria

**The task is NOT complete until ALL of these are satisfied:**

- [ ] Syntax validated — Run linters, type checkers, or `docker compose config` as appropriate
- [ ] Change tested — If a command can verify the change works, run it and read the output
- [ ] No regressions — Verify that existing functionality has not broken
- [ ] `SYSTEM_LOG.md` updated — Append timestamped entry with: summary, affected files, rationale, and breadcrumb trail
- [ ] `PORTS.md` updated — If any port assignment changed
- [ ] `Project_Context.md` updated — If any service relationship changed
- [ ] TDR created — If any new technology was introduced (see [templates/tdr-template.md](../templates/tdr-template.md))

> **Final Gate**: The task is NOT complete until documentation is updated.

---

## Integration with Global Rules

This mode inherits and extends:
- [PC2E Framework](../global/pc2e-framework.md) — Apply Predict/Communicate/Explain to implementation decisions
- [Governance Framework](../global/governance-framework.md) — All code must satisfy the 4 Core Imperatives
- [Anti-Regression Rules](../global/anti-regression-rules.md) — Implementation must not create regression opportunities
- [Mandatory Documentation](../global/mandatory-documentation.md) — Update all governance files after code changes

---

## Quick Reference

**Entry**: Read target files, verify no past failures, state plan, identify impact zone
**Operating**: Read before edit, escalate limiting choices, satisfy all 4 Core Imperatives, document decisions
**Exit**: Validate syntax, test changes, update all governance files, verify no regressions
**PC2E**: Predict success rate, communicate impact zone, explain implementation choices