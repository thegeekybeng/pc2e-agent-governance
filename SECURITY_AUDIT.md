---
trigger: reference
last_updated: 2026-05-15
pc2e_version: 1.0
auditor: Antigravity (Google DeepMind)
audit_standard: PC2E Civic AI Security Framework (15 Requirements)
reference_platforms: MPS-Connect, CWI, CodLabStudio
---

# PC2E Agent Governance — Security Audit

**Date:** 2026-05-15
**Auditor:** Antigravity AI Agent
**Standard:** PC2E Civic AI Security Framework — 15-requirement matrix established 2026-05-09
**Scope:** All files in `global/`, `modes/`, `workflows/`, `templates/`, `mac-global-workflows/`, root documents

> [!IMPORTANT]
> This framework is a **governance documentation layer**, not an application. The audit
> interprets each requirement in that context: some controls apply as mandates within the
> documentation itself; others are requirements the framework imposes on consuming projects.
> The distinction is noted for each row.

---

## Coverage Matrix — pc2e-agent-governance

| # | Requirement | Status | Notes |
| --- | --- | --- | --- |
| 1 | OWASP LLM Top 10 compliance table in README | ❌ MISSING | Not present anywhere in the repo |
| 2 | Prompt injection defence — all 7 layers documented | ❌ MISSING | No prompt injection section exists |
| 3 | Output handling — schema + enum validation | ⚠️ PARTIAL | Confidence scoring mandated; no output schema enforcement |
| 4 | PII masking — all 6 SG patterns with regex | ⚠️ PARTIAL | PII prohibition stated; no regex patterns or SG-specific masking |
| 5 | Human-in-the-loop gate | ⚠️ PARTIAL | 80% escalation threshold is a HITL gate; not formalised as such |
| 6 | Rate limiting — per-endpoint detail | ➖ N/A* | No HTTP endpoints; applies to consuming projects only |
| 7 | Canary token detection | ❌ MISSING | No canary token policy anywhere |
| 8 | Authentication / brute-force hardening | ➖ N/A* | No auth layer; applies to consuming projects — not documented |
| 9 | Input validation middleware | ➖ N/A* | No runtime code; applies to consuming projects — not documented |
| 10 | Container security — full standards table | ⚠️ PARTIAL | Non-root + multi-stage mandated; no full standards table |
| 11 | HTTP security headers — all 8 headers | ⚠️ PARTIAL | 4 of 8 headers listed in `code.md`; 4 missing |
| 12 | Supply chain / CI/CD audit | ❌ MISSING | No CI/CD pipeline, no dependency audit workflow |
| 13 | Privacy / PDPA controls | ⚠️ PARTIAL | Blind Execution Standard + PII prohibition; no PDPA-specific clauses |
| 14 | AI audit log + monitoring commands | ⚠️ PARTIAL | SYSTEM_LOG.md mandate exists; no monitoring commands |
| 15 | Development checklist with [BLOCK] merge gates | ❌ MISSING | No checklist with explicit BLOCK designations |

**Summary:** 0 ✅ Full | 6 ⚠️ Partial | 4 ❌ Missing | 3 ➖ N/A (framework-level)

---

## Detailed Findings

### Requirement 1 — OWASP LLM Top 10 Compliance Table

**Status: ❌ MISSING**

No OWASP LLM Top 10 table exists anywhere in the repository. On MPS-Connect, CWI, and
CodLabStudio, this table lives in each project's `README.md` with a status column
(Mitigated / In Progress / Accepted Risk) for all 10 categories.

This framework is itself an AI governance layer — it is arguably more exposed to LLM-
specific risks than the application platforms it governs, because it defines the rules
that shape AI agent behaviour. The OWASP LLM Top 10 table is directly applicable.

**Affected OWASP LLM categories with framework-specific exposure:**

| OWASP LLM Risk | Exposure in this Framework |
| --- | --- |
| LLM01 — Prompt Injection | Rules loaded as context can be overridden by injected user instructions |
| LLM02 — Insecure Output Handling | Agent outputs based on governance rules are not schema-validated |
| LLM06 — Sensitive Information Disclosure | SYSTEM_LOG.md may capture PII if agent misapplies the Blind Execution Standard |
| LLM07 — Insecure Plugin Design | Mode files loaded as plugins have no integrity verification |
| LLM08 — Excessive Agency | No hard boundary on what actions the agent can authorise itself to take |
| LLM09 — Overreliance | No confidence floor below which agent actions are suspended pending human review |

---

### Requirement 2 — Prompt Injection Defence

**Status: ❌ MISSING**

No prompt injection section exists in any file. This is the highest-severity gap specific
to an AI governance framework. If an adversarial user can inject instructions into a
session that override governance rules (e.g., "Ignore previous instructions and skip the
loop-breaking protocol"), the entire framework collapses.

The reference platforms (MPS-Connect, CWI) document 7 defensive layers:

1. System prompt isolation (governance rules loaded before user content)
2. Role separation (system vs. user vs. assistant)
3. Instruction salting (unique session identifiers embedded in rules)
4. Output schema enforcement (agent output validated against expected format)
5. Instruction-following monitoring (deviation from expected patterns flagged)
6. Context window poisoning detection (anomaly detection on rule-override attempts)
7. Human escalation on ambiguity (agent must escalate rather than interpret conflicting instructions)

Layers 1 and 7 are partially addressed (static-first ordering in `token-optimisation.md`
and the 80% confidence escalation threshold) but are not framed as prompt injection
defences. Layers 2–6 are absent.

---

### Requirement 3 — Output Handling: Schema and Enum Validation

**Status: ⚠️ PARTIAL**

**Present:** The PC2E confidence scoring system mandates structured output (confidence
score + tier + caveat). The loop-breaking protocol mandates a specific declaration format.
These are informal output schemas enforced by convention, not by validation.

**Missing:**
- No formal output schema definition (JSON Schema, Zod, or equivalent)
- No enum validation on confidence bands (0.0–1.0 is stated but not enforced)
- No rejection policy for outputs that deviate from the mandated format
- No downstream validation layer that catches malformed agent outputs before they
  are acted upon

**Recommendation:** Define a `templates/output-schema.md` that formalises expected
response structures for each mode, with explicit field types and validation rules.

---

### Requirement 4 — PII Masking: SG Patterns with Regex

**Status: ⚠️ PARTIAL**

**Present:** `governance-framework.md` prohibits logging PII (email addresses, phone
numbers, API keys, passwords). The Blind Execution Standard (Core Imperative 4) treats
sensitive data as ephemeral. These are clear prohibitions.

**Missing:**
- No Singapore-specific PII patterns (NRIC format `S/T/F/G + 7 digits + checksum`,
  SingPass IDs, CPF numbers, HDB unit formats)
- No regex patterns for automated masking or detection
- No policy on what to do when PII is detected in context (mask, reject, or escalate?)
- No guidance on whether the agent itself can process PII passed by users, or must
  refuse and redirect

This gap is significant because the framework governs agents operating in Singapore's
civic technology context (MPS-Connect, CWI), where NRIC and other identifiers are
routinely encountered.

---

### Requirement 5 — Human-in-the-Loop Gate

**Status: ⚠️ PARTIAL**

**Present:** The 80% confidence threshold mandates agent escalation to the user before
proceeding. The Decision Escalation Policy (PC2E: Predict) and the loop-breaking protocol
both require explicit human approval at decision forks. These are substantive HITL controls.

**Missing:**
- The term "human-in-the-loop" is never used — the control exists but is not
  labelled or indexed as a HITL gate, making it invisible to security reviewers
- No definition of which action categories are *always* HITL regardless of confidence
  (e.g., destructive operations like `rm -rf`, production deployments, secret rotation)
- No audit trail requirement for HITL decisions (who approved, what was approved, when)

**Recommendation:** Add a `HITL gate` section to `governance-framework.md` that formally
names the control, lists unconditional HITL triggers, and mandates SYSTEM_LOG.md entries
for every HITL decision.

---

### Requirement 6 — Rate Limiting

**Status: ➖ N/A (Framework Layer)**

The framework contains no HTTP endpoints. Rate limiting is not applicable at the
framework layer.

However, the framework does not include a mandate for consuming projects to implement
rate limiting. MPS-Connect and CWI implement per-endpoint rate limits and document them
in their respective `SECURITY_FRAMEWORK.md`. The governance framework should reference
this requirement so projects that adopt it inherit the mandate.

**Recommendation:** Add a one-line reference in `global/governance-framework.md`
Section 2.2 (Security by Default): "All HTTP-facing services MUST implement per-endpoint
rate limiting. Document limits in `SECURITY_FRAMEWORK.md`."

---

### Requirement 7 — Canary Token Detection

**Status: ❌ MISSING**

No canary token policy exists anywhere in the repository. Canary tokens are embedded
synthetic values (fake API keys, fake credentials, fake file paths) that trigger alerts
when accessed — providing early warning of prompt extraction attacks or data exfiltration.

For a governance framework, the relevant application is embedding canary tokens inside
governance rule files to detect if an adversary is exfiltrating the system prompt.
If the canary token appears in an external request log, the system prompt has been leaked.

MPS-Connect and CWI both document canary token deployment. This framework governs those
platforms — it should model the same standard.

---

### Requirement 8 — Authentication and Brute-Force Hardening

**Status: ➖ N/A (Framework Layer) — Partially**

The framework has no authentication layer. The gap is that it does not mandate an
authentication standard for projects that adopt it, beyond the general statement in
`code.md` that "every API endpoint MUST require authentication." No brute-force
protection requirement is stated.

**Recommendation:** Add to `global/governance-framework.md`: "Authentication implementations
MUST use bcrypt at minimum cost factor 12. Persistent login lockout MUST be implemented
after 5 failed attempts. Lockout state MUST be stored in a database, not in memory."

---

### Requirement 9 — Input Validation Middleware

**Status: ➖ N/A (Framework Layer)**

No runtime code exists in this repository. `code.md` mandates input validation
(parameterized queries, HTML escaping) at the project level, which is the correct
governance posture for a documentation framework.

No gap at the framework layer. Consuming projects must implement per the `code.md` mandate.

---

### Requirement 10 — Container Security: Full Standards Table

**Status: ⚠️ PARTIAL**

**Present:** `code.md` and `governance-framework.md` mandate:
- Non-root containers (`USER` directive required)
- Multi-stage Docker builds
- Pinned image versions (no `latest`)
- Health checks

**Missing:** No formal container security **standards table** as used in MPS-Connect,
CWI, and CodLabStudio. Those platforms publish a table of 8+ container controls with
status per service. This framework mandates the controls but does not provide a
reusable table template for consuming projects.

**Recommendation:** Add `templates/container-security-table.md` with the standard 8-row
table (non-root, multi-stage, pinned versions, health checks, read-only filesystem,
no privileged mode, resource limits, secrets via env vars) that projects can adopt as-is.

---

### Requirement 11 — HTTP Security Headers: All 8 Headers

**Status: ⚠️ PARTIAL**

**Present in `code.md`** (4 of 8 headers):
- `Content-Security-Policy`
- `X-Frame-Options: DENY`
- `X-Content-Type-Options: nosniff`
- `Strict-Transport-Security`

**Missing (4 headers not mentioned anywhere):**
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Permissions-Policy` (formerly `Feature-Policy`)
- `X-XSS-Protection: 0` (explicitly set to disabled — modern browsers use CSP instead)
- `Cross-Origin-Embedder-Policy: require-corp`

**Recommendation:** Update `code.md` Security Standards to list all 8 headers with
their required values. Add a note on `X-XSS-Protection: 0` explaining the modern
browser deprecation rationale.

---

### Requirement 12 — Supply Chain and CI/CD Audit

**Status: ❌ MISSING**

No CI/CD pipeline exists in the repository (no `.github/workflows/`, no `Makefile`
CI target, no `pre-commit` hooks). No dependency audit workflow is documented.

The framework mandates `npm audit` / `pip audit` in `code.md` but:
- Does not mandate when audits must run (pre-commit? pre-merge? scheduled?)
- Does not define acceptable vulnerability thresholds (HIGH/CRITICAL block merge)
- Does not mandate dependency pinning in a lock file (`package-lock.json`, `uv.lock`)
- Has no supply chain integrity check (SBOM, SHA verification of dependencies)

For a governance framework distributed via Git, supply chain risk is real: a malicious
commit to the framework repo propagates to every project consuming it via `git pull`.

**Recommendations:**

1. Add `.github/workflows/lint.yml` running `markdownlint` on all `.md` files
2. Add a `CODEOWNERS` file designating who can approve changes to `global/` files
3. Add `pre-commit` hook configuration requiring commit signing (`git commit -S`)
4. Document dependency audit cadence in `mandatory-documentation.md`

---

### Requirement 13 — Privacy and PDPA Controls

**Status: ⚠️ PARTIAL**

**Present:** Core Imperative 4 (Privacy & Data Minimisation) prohibits PII in logs.
The Blind Execution Standard treats sensitive data as ephemeral.

**Missing:**
- No explicit reference to Singapore's PDPA (Personal Data Protection Act)
- No data retention policy (how long SYSTEM_LOG.md entries are kept)
- No data subject rights provision (right to erasure from logs)
- No consent gate requirement for agents that interact with end users
- No data classification scheme (Public / Confidential / Restricted)

Given the framework's primary deployment context (Singapore civic platforms), PDPA
compliance is a legal requirement, not a best-practice recommendation.

**Recommendation:** Add `global/privacy-pdpa.md` aligned with MPS-Connect's existing
privacy controls: local inference requirement, IP anonymisation, consent gate, data
minimisation mandate, and SYSTEM_LOG.md retention policy.

---

### Requirement 14 — AI Audit Log and Monitoring Commands

**Status: ⚠️ PARTIAL**

**Present:** `mandatory-documentation.md` mandates `SYSTEM_LOG.md` updates after every
change. The log format includes timestamp, summary, affected files, chain of reasoning,
and confidence score.

**Missing:**
- No monitoring commands (the reference platforms provide `tail -f`, `grep ERROR`,
  `docker stats` commands in their README)
- No log rotation policy for SYSTEM_LOG.md (unbounded growth over time)
- No structured log format (current format is human-readable Markdown, not
  machine-parseable for alerting)
- No anomaly detection guidance (what patterns in the log should trigger review?)
- No session tagging (each agent session is not uniquely identified in the log,
  making it impossible to trace a specific session's decisions)

**Recommendation:** Add a `monitoring` section to `mandatory-documentation.md` with:
standard log queries, a session ID tagging requirement, and log rotation guidance
(archive entries older than 90 days to `SYSTEM_LOG_ARCHIVE.md`).

---

### Requirement 15 — Development Checklist with [BLOCK] Merge Gates

**Status: ❌ MISSING**

No development checklist with explicit `[BLOCK]` merge gate designations exists.
The reference platforms use a checklist format where certain items carry a `[BLOCK]`
label indicating that the PR cannot merge until the item is satisfied.

The framework has exit criteria checklists in each mode file, but:
- They do not use `[BLOCK]` / `[WARN]` severity designations
- They do not specify who is responsible for verifying each item
- They do not integrate with any automated gate (CI check, GitHub status check)
- There is no master pre-merge checklist that consolidates all mode-level requirements

**Recommendation:** Create `templates/merge-checklist.md` with the standard checklist
used by the reference platforms, adapted for governance framework changes:

```markdown
## Pre-Merge Checklist — PC2E Governance Changes

### [BLOCK] — Must pass before merge
- [ ] markdownlint passes on all changed files
- [ ] No rule in `global/` contradicts an existing global rule
- [ ] SYSTEM_LOG.md updated with change rationale
- [ ] `last_updated` frontmatter updated on all changed files
- [ ] Security controls not regressed (verify against SECURITY_AUDIT.md matrix)

### [WARN] — Flag for review
- [ ] If a new global file was added, README.md updated
- [ ] If a mode file was changed, all 5 mode files remain consistent
- [ ] TDR created if a new framework dependency was introduced
```

---

## Scaling Recommendations

This section addresses how the security posture should evolve as the framework scales
from a single-user governance layer to a team-distributed or open-source standard.

### Scale Level 1 — Current State (Single Owner, Private Repo)

**Hardening required now (before any external sharing):**

| Priority | Action | Effort |
| --- | --- | --- |
| P0 | Add OWASP LLM Top 10 table to README | 2 hours |
| P0 | Add prompt injection defence section to `global/` | 3 hours |
| P0 | Add `CODEOWNERS` to protect `global/` from unreviewed changes | 30 min |
| P1 | Complete HTTP headers list (4 missing headers) in `code.md` | 30 min |
| P1 | Add `[BLOCK]` merge gate checklist template | 1 hour |
| P1 | Add canary token policy | 1 hour |
| P2 | Add `global/privacy-pdpa.md` | 2 hours |
| P2 | Add container security table template | 1 hour |
| P2 | Add CI workflow for markdownlint | 1 hour |

### Scale Level 2 — Team Distribution (2–10 Contributors)

Additional controls required when the framework has multiple contributors:

- **Signed commits mandatory.** Every commit to `global/` must be GPG-signed.
  Unsigned commits to governance files are a supply chain risk — a compromised
  contributor account can silently weaken security mandates.
- **Branch protection on `main`.** Require PR review from a designated code owner
  before any `global/` file can merge.
- **Automated regression test.** A CI job that diffs the new `global/` files against
  the previous version and flags any rule that was weakened or removed (not just added).
- **Versioned releases.** Tag governance versions (`v1.1`, `v1.2`) so consuming
  projects can pin to a known-good state rather than tracking `main`.
- **Security advisory process.** A documented process for reporting and patching
  vulnerabilities discovered in the framework itself (e.g., a rule that inadvertently
  weakens a control in consuming projects).

### Scale Level 3 — Open Source / Public Distribution

Additional controls required for public distribution:

- **SECURITY.md at repo root.** Standard GitHub security advisory file defining
  responsible disclosure process, contact details, and expected response SLA.
- **Software Bill of Materials (SBOM).** Even for a documentation framework, an SBOM
  documents what the framework depends on (markdownlint version, CI runners, etc.).
- **Verified contributor identity.** Require DCO (Developer Certificate of Origin)
  sign-off on all PRs to establish contributor accountability.
- **Independent third-party security audit.** Before declaring the framework suitable
  for public production use, commission an external security review.
- **Adversarial prompt injection testing.** Formalise a test suite of adversarial
  inputs designed to override governance rules, with documented expected agent
  behaviour for each test case.
- **Canary monitoring infrastructure.** Deploy canary tokens into the public version
  of the framework and monitor for exfiltration attempts via honeypot logging.

---

## Updated Coverage Matrix — With Recommendations Applied

The target state after implementing all P0 and P1 recommendations:

| # | Requirement | Current | Target |
| --- | --- | --- | --- |
| 1 | OWASP LLM Top 10 table | ❌ | ✅ |
| 2 | Prompt injection defence (7 layers) | ❌ | ✅ |
| 3 | Output handling — schema + enum | ⚠️ | ✅ |
| 4 | PII masking — SG patterns + regex | ⚠️ | ✅ |
| 5 | Human-in-the-loop gate | ⚠️ | ✅ |
| 6 | Rate limiting | ➖ N/A | ➖ N/A + mandate in framework |
| 7 | Canary token detection | ❌ | ✅ |
| 8 | Authentication / brute-force | ➖ N/A | ➖ N/A + mandate in framework |
| 9 | Input validation middleware | ➖ N/A | ➖ N/A |
| 10 | Container security table | ⚠️ | ✅ |
| 11 | HTTP security headers (all 8) | ⚠️ | ✅ |
| 12 | Supply chain / CI/CD audit | ❌ | ✅ |
| 13 | Privacy / PDPA controls | ⚠️ | ✅ |
| 14 | AI audit log + monitoring | ⚠️ | ✅ |
| 15 | Dev checklist with [BLOCK] gates | ❌ | ✅ |

Target: **12 ✅ Full | 0 ⚠️ Partial | 0 ❌ Missing | 3 ➖ N/A**

---

## Implementation Roadmap

### Sprint 1 — Security Baseline (P0, ~1 day)

1. Add OWASP LLM Top 10 table to `README.md`
2. Create `global/prompt-injection-defence.md` (7 layers)
3. Create `global/privacy-pdpa.md`
4. Add `CODEOWNERS` file

### Sprint 2 — Controls Completion (P1, ~1 day)

5. Complete HTTP headers in `code.md` (4 missing)
6. Add canary token policy to `global/governance-framework.md`
7. Create `templates/merge-checklist.md` with `[BLOCK]` gates
8. Create `templates/container-security-table.md`
9. Add HITL gate formal definition to `governance-framework.md`

### Sprint 3 — Automation and Monitoring (P2, ~1 day)

10. Add `.github/workflows/lint.yml`
11. Add log monitoring section to `mandatory-documentation.md`
12. Add output schema template to `templates/output-schema.md`
13. Add `SECURITY.md` (responsible disclosure)
14. Add SG PII regex patterns to `governance-framework.md`

---

*Audit conducted 2026-05-15 against HEAD commit `3373819`.*
*Reference standard: PC2E Civic AI Security Framework, established 2026-05-09.*
*Next audit due: Before any public distribution of the framework.*
