# Architect Mode

> **Purpose**: Design decisions, service relationships, and technology selection
> **Precedence**: Supplements global rules from [global/](../global/)
> **Last Updated**: 2026-03-19

---

## Entry Gate (MANDATORY)

**BEFORE proposing ANY architectural change, complete these pre-flight checks:**

- [ ] Read `Project_Context.md` — Understand current service architecture, relationships, and constraints
- [ ] Read `PORTS.md` — Know what ports are allocated and what's available
- [ ] Read `SYSTEM_LOG.md` — Review past decisions (do NOT re-propose approaches that already failed)
- [ ] State the design intent — Describe: (a) problem being solved, (b) constraints, (c) trade-offs

> **Violation Consequence**: Skipping this gate may cause designs that conflict with existing architecture.

---

## Operating Standards

### Decision Escalation (PC2E: Predict - HIGHEST PRIORITY)

Architecture decisions are the **most limiting** choices in any project. Before proposing any design, verify you are NOT making a limiting choice:

- **Technology selection**: Is this the best choice, or just the first one you thought of? Score it against alternatives.
- **Coupling**: Does this create a dependency between services that were previously independent?
- **Scalability**: Can this design handle 10x load without re-architecture?
- **Migration path**: Can this technology be replaced later without rewriting the whole service?

If ANY of these checks raise concerns, **STOP and present alternatives before proceeding with the design.**

> **Consequence**: Proposing a limiting architecture = rework for both the design AND the implementation.

### Architecture Principles

- **Decoupling first**: Services MUST be independently deployable (no hidden cross-service dependencies)
- **Port authority**: Every new service MUST have a port assignment documented in `PORTS.md` BEFORE implementation
- **Nginx facades**: All web-facing services MUST be fronted by Nginx with proper security headers
- **Stateless services**: Prefer stateless designs; if state is required, document the persistence mechanism

### Scalability-First Design (Core Imperative #1)

Every architectural proposal MUST address scalability as the primary design constraint:

- **Horizontal scaling**: Design services to run as multiple replicas behind a load balancer (no in-memory session state)
- **Database scalability**: Specify connection pooling, read replicas, and indexing strategy for every data store
- **Queue-based processing**: Long-running operations MUST use message queues (Redis, RabbitMQ) rather than synchronous processing
- **Caching strategy**: Define caching layers (CDN, application cache, database cache) and invalidation rules
- **10x test**: Every design MUST answer: "Can this handle 10x the expected load without re-architecture?" (Document the answer)
- **Bottleneck identification**: Every design MUST identify the most likely scaling bottleneck and the mitigation plan

### Security Architecture (Core Imperative #2)

Every architectural proposal MUST include a security model:

- **Authentication design**: How users and services authenticate (prefer token-based: JWT, OAuth2)
- **Authorization model**: How permissions are enforced (document role hierarchies and access control rules)
- **Network security**: Define which services are publicly accessible vs internal-only (use network segmentation)
- **Secret management**: Specify how secrets are stored, rotated, and accessed (NEVER design for hardcoded secrets)
- **Attack surface analysis**: For every external-facing component, document potential attack vectors and mitigations
- **Dependency security**: All proposed dependencies MUST have known-vulnerability checks as part of the design

### Tech Decision Records (MANDATORY for new technologies)

**For EVERY new technology proposed in a design, produce a TDR using [templates/tdr-template.md](../templates/tdr-template.md):**

> **Threshold**: Do NOT propose any technology scoring below 5 on EITHER metric without explicit user approval.

Use the [Scoring Rubric](../templates/scoring-rubric.md) to evaluate technologies consistently.

### Anti-Technical-Debt Design (Core Imperative #3)

- **No over-engineering**: Design for current requirements, not hypothetical future ones (keep it simple)
- **No dependency bloat**: Every library in the design MUST earn its place (if standard library can do it, use standard library)
- **Migration paths**: When proposing a technology, always note how it can be replaced if it becomes unmaintained

### PC2E Integration

#### Predict
- **Score confidence** (0-100%) in the proposed architecture
- If confidence < 80%, list exact missing context before proceeding
- **Score alternatives**: Use the [Scoring Rubric](../templates/scoring-rubric.md) to compare options

#### Communicate
- **State design assumptions** before presenting the architecture
- **Declare constraints** that limit the design space
- **Explain tool/technology choices** with specific rationale

#### Explain
- **Document Chain of Reasoning**: Requirements → Constraints → Options → Choice
- **Explain why rejected alternatives would fail** (be specific about failure modes)
- **Make trade-offs explicit**: What are we optimizing for? What are we sacrificing?

---

## Design Documentation Requirements

Every architectural proposal MUST include:

1. **Service diagram** — Which services exist, how they connect, what ports they use
2. **Data flow** — How data moves between services
3. **Failure modes** — What happens when each service goes down
4. **Security model** — How authentication, authorization, and encryption are handled
5. **Deployment model** — How the service is containerized, configured, and scaled

---

## Anti-Patterns (NEVER)

- ❌ **NEVER propose a technology without scoring alternatives** — This is a limiting choice
- ❌ **NEVER design tightly-coupled services** — Independent deployability is non-negotiable
- ❌ **NEVER skip the scalability section** — It's the highest priority imperative
- ❌ **NEVER assume a technology is "good enough"** — Score it or escalate

---

## Exit Criteria

**The design is NOT complete until ALL of these are satisfied:**

- [ ] All architectural decisions have TDRs with scored alternatives
- [ ] Scalability analysis completed (including 10x test)
- [ ] Security model documented with attack surface analysis
- [ ] Failure modes and resilience strategy documented
- [ ] `Project_Context.md` updated to reflect the new or modified architecture
- [ ] `PORTS.md` updated with port reservations for new services
- [ ] `SYSTEM_LOG.md` updated with architectural decision, rationale, timestamp, and affected services

> **Final Gate**: The design is NOT complete until documentation is updated.

---

## Integration with Global Rules

This mode inherits and extends:
- [PC2E Framework](../global/pc2e-framework.md) — Apply Predict/Communicate/Explain to architecture decisions
- [Governance Framework](../global/governance-framework.md) — All designs must satisfy the 4 Core Imperatives (especially Scalability first)
- [Anti-Regression Rules](../global/anti-regression-rules.md) — Designs must not introduce technical debt
- [Mandatory Documentation](../global/mandatory-documentation.md) — TDRs are mandatory for new technologies

---

## Quick Reference

**Entry**: Read context files, state design intent, verify no past failures
**Operating**: Score alternatives, design for 10x scale, document security model, produce TDRs
**Exit**: Update all governance files, verify all TDRs complete, ensure no limiting choices made
**PC2E**: Predict architecture success rate, communicate constraints, explain trade-offs explicitly