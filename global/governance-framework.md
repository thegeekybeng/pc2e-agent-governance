---
trigger: always_on
last_updated: 2026-05-15
pc2e_version: 1.0
---

# Workspace Governance Framework

> This framework enforces good code development practices, documentation standards, and quality gates across all AI-assisted work in this workspace.

---

## CORE IMPERATIVES (Non-Negotiable — Apply to ALL Sections)

Every implementation in this workspace MUST satisfy these four imperatives. They are listed in priority order:

### Imperative 1: SCALABILITY (Highest Priority)

Every design and implementation MUST be horizontally scalable. Single points of failure are forbidden.

**Requirements:**

- Services MUST be stateless wherever possible
- When state is required, use externalized state stores (databases, caches) that can themselves be scaled
- Database queries MUST be indexed and optimized (no full-table scans in production code)
- Container orchestration MUST support replica scaling (e.g., `deploy.replicas` in compose, or Kubernetes-ready patterns)
- Load testing considerations MUST be documented for any service handling external traffic

**Verification Question:**
> **Before declaring any task complete, answer**: "Can this service handle 10x current load without architectural changes?" If not, redesign.

---

### Imperative 2: SECURITY (Zero-Vulnerability Mandate)

**Security audit is MANDATORY** for every implementation. Before declaring any code change complete, the AI Agent MUST:

1. **Review all inputs** for injection vulnerabilities (SQL injection, XSS, command injection, path traversal)
2. **Verify all secrets** are in environment variables or secret stores — NEVER in code, config files, or logs
3. **Verify all Docker containers** run as non-root users with minimal capabilities
4. **Verify all web-facing services** enforce security headers:
   - Content-Security-Policy
   - X-Frame-Options: DENY
   - X-Content-Type-Options: nosniff
   - Strict-Transport-Security
5. **Verify all API endpoints** have authentication and authorization checks
6. **Verify all dependencies** are current and free of known CVEs (check with `npm audit`, `pip audit`, or equivalent)
7. **Verify CORS policies** are restrictive (no wildcard `*` origins in production)
8. **Verify TLS/HTTPS** is enforced for all external communications

**Log all security findings** in `SYSTEM_LOG.md` as part of the post-implementation entry.

> **If a vulnerability cannot be resolved**, STOP and escalate to the user with a clear description of the risk.

---

### Imperative 3: ZERO TECHNICAL DEBT (0% Target)

Every implementation MUST be production-quality from the first commit. No "we'll fix it later" patterns.

**Debt Indicators That Are FORBIDDEN:**

- TODO/FIXME/HACK comments without a corresponding `SYSTEM_LOG.md` entry and resolution timeline
- Deprecated API or library usage without an active migration plan
- Copy-pasted code (must be abstracted into shared utilities)
- Magic numbers or hardcoded values (must use named constants or config)
- Missing error handling (every failure path must be explicitly handled)
- Unused imports, variables, or dead code
- Missing type annotations in TypeScript/Python code
- Functions longer than 50 lines (refactor into smaller, testable units)
- Circular dependencies between modules

**Debt Audit Checklist** — Verify EACH item before declaring a task complete:

- [ ] No TODO/FIXME/HACK comments without SYSTEM_LOG.md entries
- [ ] No deprecated APIs or libraries
- [ ] No duplicated code blocks
- [ ] No magic numbers or hardcoded values
- [ ] All error paths are handled
- [ ] No unused code
- [ ] All functions are under 50 lines
- [ ] No circular dependencies

---

### Imperative 4: STRICT PRIVACY & DATA MINIMIZATION (PC2E Mandate)

**The AI Agent MUST NEVER** log or output sensitive Personal Identifiable Information (PII), proprietary business logic secrets, or raw database dumps into `SYSTEM_LOG.md` or terminal output.

**Standards:**

- **Blind Execution Standard**: When processing sensitive data or proprietary algorithms, the agent must treat the data as ephemeral. It must immediately flush that data from its active reasoning context once the operation succeeds.
- **Data Logging**: If data logging is necessary for debugging, the agent MUST anonymize or intentionally redact the output.
- **PII Protection**: Never log email addresses, phone numbers, API keys, passwords, or personal data.

---

## SECTION 1: Governance File Intake (MANDATORY — Every Session)

**BEFORE any work begins, the AI Agent MUST read and internalize these three files:**

| # | File | Purpose | Relative Path |
| --- | ------ | --------- | --------------- |
| 1 | **PORTS.md** | Authoritative port assignment ledger | `PORTS.md` |
| 2 | **Project_Context.md** | Service architecture and relationship map | `Project_Context.md` |
| 3 | **SYSTEM_LOG.md** | Audit trail of all technical decisions | `SYSTEM_LOG.md` |

**Rules:**

- Read these files at the START of every session
- Read these files AGAIN when encountering looping bugs (more than 2 failed attempts at the same fix)
- Update ALL THREE files BEFORE ending any session where changes were made
- NEVER assume you know the current state; always verify with a fresh read

---

## SECTION 2: Code Development Standards

### 2.1 Pre-Implementation Design Gate

**BEFORE writing any code, the AI Agent MUST:**

1. **Understand the full project context** — Read the project's existing files, folder structure, and dependencies
2. **Map the impact zone** — Identify ALL files that will be affected by the proposed change. List them explicitly.
3. **Verify port availability** — Check `PORTS.md` for collisions before assigning any port
4. **Check for prior failures** — Read `SYSTEM_LOG.md` to confirm the proposed approach has not already been tried and failed
5. **Document the plan** — Before implementation, state: (a) what will change, (b) which files are affected, (c) what the expected outcome is

### 2.2 Implementation Standards

**File Discipline:**

- **No orphaned files**: Every file created MUST be referenced by at least one other file (docker-compose, import, config, or documentation). If a file exists in isolation, it is an error.
- **Read before edit**: ALWAYS use the Read tool on a file before modifying it. Never modify a file based on assumptions.
- **Minimal changes**: Make the smallest change that solves the problem. Do not refactor unrelated code unless explicitly asked.

**Security by Default:**

- **No hardcoded secrets**: Environment variables for ALL credentials, API keys, and sensitive configuration. Use `.env` files.
- **`.env` in `.gitignore`**: Every project MUST list `.env` and `.env.*` in `.gitignore` BEFORE writing any secrets to those files. Verify with: `grep -q "^\.env" .gitignore || echo "WARNING: .env not in .gitignore"`
- **No root containers**: All Docker services MUST run as non-privileged users.
- **Multi-stage Docker builds**: Production images MUST use multi-stage builds.

**Code Quality:**

- **Consistent naming**: Follow the existing naming conventions in the project. Do not introduce new patterns without explicit user approval.
- **Error handling**: Every service MUST include proper error handling with meaningful error messages. No silent failures.
- **Type safety**: Use TypeScript strict mode for JS projects and type hints for Python projects.

### 2.3 Decision Escalation Policy (Reinforces PC2E Framework)

**The AI Agent MUST NOT proceed with any approach that limits the project's future options.** When the AI detects it is about to make a limiting choice, it MUST:

1. **STOP** — Do not write the code or make the change
2. **State the limitation** — Explain clearly what the limiting choice is and why it's limiting
3. **Present alternatives** — Offer at least 2 better approaches with trade-offs
4. **Wait for user direction** — Do NOT proceed until the user explicitly approves

**Limiting choices include but are not limited to:**

- Using in-memory storage when a persistent/scalable alternative exists
- Implementing a workaround instead of a proper fix
- Choosing a technology scoring below 7/10 on compatibility or maintainability
- Skipping pagination, auth, or error handling to "keep it simple"
- Hardcoding values that should be configurable
- Using deprecated APIs when current versions exist

> **CONSEQUENCE: Implementing a limiting choice without escalating WILL result in mandatory rework.**

### 2.4 Anti-Technical-Debt Policy

The AI Agent MUST actively prevent technical debt by following these rules:

- **NEVER use deprecated libraries or APIs** without explicitly flagging them and providing migration paths
- **NEVER add a dependency** without documenting: (a) what it does, (b) why it's needed, (c) its maintenance status, (d) one alternative that could achieve the same purpose
- **NEVER write "quick fix" code** that bypasses proper architecture. If a shortcut is tempting, document why the proper approach is better and implement it instead
- **NEVER leave TODO comments** without a corresponding entry in `SYSTEM_LOG.md`
- **Code readability over cleverness** — Write code that another developer can understand within 30 seconds of reading. Prefer explicit over implicit

---

## SECTION 3: Technology Documentation Standard

### 3.1 Tech Decision Record (TDR)

**Every technology, library, and framework used in every project MUST have documented trade-offs.**

This applies to:

- **New technologies** — Document BEFORE implementing (part of Decision Escalation)
- **Existing undocumented technologies** — When working on a project and you encounter a technology without a TDR in `SYSTEM_LOG.md`, document it as part of your current task
- **Technology changes** — When upgrading, replacing, or modifying a technology, update or create the TDR

**See**: [TDR Template](../templates/tdr-template.md) for the standard format.

### 3.2 Scoring Rubric

**See**: [Scoring Rubric](../templates/scoring-rubric.md) for detailed evaluation criteria.

**Threshold**: Do NOT use any technology scoring below 5 on EITHER metric without explicit user approval.

---

## SECTION 4: Testing and Validation Requirements

### 4.1 Sandbox-First Development

**BEFORE deploying or telling the user a change is complete, the AI Agent MUST:**

1. **Validate syntax** — Run appropriate linters or syntax checks on all modified files
2. **Test configuration** — For Docker changes, run `docker compose config` (or equivalent) to validate the compose file
3. **Verify connectivity** — For services that depend on other services, verify the dependency chain is correct
4. **Check container health** — After any Docker change, verify containers start and pass health checks
5. **Monitor terminal output** — READ the terminal output after running commands. Do not assume success. React to errors before proceeding.

### 4.2 Testing Checklist

The AI Agent MUST verify EACH of the following before declaring a task complete:

- [ ] All modified files have valid syntax
- [ ] No port conflicts exist (verified against `PORTS.md`)
- [ ] Docker services start successfully (if applicable)
- [ ] Health checks pass (if applicable)
- [ ] No error output in terminal logs
- [ ] Documentation has been updated

---

## SECTION 5: Documentation Lifecycle

### 5.1 Continuous Documentation

- **Log every change**: After EVERY successful implementation, IMMEDIATELY append an entry to `SYSTEM_LOG.md` — do not batch; do not "remember to do it later"
- **Breadcrumb trail**: Every `SYSTEM_LOG.md` entry MUST include: timestamp (UTC), summary, affected files list, and rationale for the approach
- **Update `PORTS.md`** whenever any port assignment changes
- **Update `Project_Context.md`** whenever service architecture or relationships change
- **No orphaned documentation**: Every doc file MUST be referenced or linked from a parent document

**See**: [System Log Entry Template](../templates/system-log-entry-template.md) for the standard format.

### 5.2 Consistency Enforcement

- Do not create a new file simply because it's convenient. Every file MUST have a clear purpose.
- If a file is no longer needed, delete it and update all references.
- The AI Agent's interpretation of instructions may differ from the user's. When instructions are ambiguous, CLARIFY before implementing. Do not give a one-line reply and expect the user to understand.

---

## SECTION 6: Mode-Specific Application

This governance framework applies to ALL modes. Each mode extends these rules with mode-specific requirements:

- **Orchestrator Mode**: See [modes/orchestrator.md](../modes/orchestrator.md)
- **Architect Mode**: See [modes/architect.md](../modes/architect.md)
- **Code Mode**: See [modes/code.md](../modes/code.md)
- **Debug Mode**: See [modes/debug.md](../modes/debug.md)
- **Ask Mode**: See [modes/ask.md](../modes/ask.md)

---

## SECTION 7: Token Optimisation

Token consumption is a resource governance imperative under Core Imperative 1 (Scalability).
Deploying this framework without applying prompt caching where the provider supports it
is a scalability violation.

**See**: [global/token-optimisation.md](token-optimisation.md) for the four methods,
priority order, loading strategy by context budget, and the token budget decision tree.

---

## Enforcement

These rules are **mandatory** and apply to every task. Violations result in:

- Task marked as incomplete
- Mandatory rework
- Documentation of the violation in `SYSTEM_LOG.md`

**The Four Imperatives are non-negotiable.** There are no exceptions without explicit user override.
