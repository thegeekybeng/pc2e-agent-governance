---
trigger: always_on
last_updated: 2026-03-19
pc2e_version: 1.0
---

# Mandatory Documentation Standards

> Documentation is not optional. It is a core deliverable that must be completed before any task is considered done.

---

## Core Principle

**Documentation is a first-class deliverable, equal in importance to code.**

Every technical decision, implementation, and change MUST be documented. Undocumented work is incomplete work.

---

## The Three Governance Files

These files are the authoritative source of truth for the workspace. They MUST be kept current.

### 1. SYSTEM_LOG.md

**Purpose:** Audit trail of all technical decisions, changes, and incidents.

**When to Update:**

- After EVERY successful implementation (immediately, not batched)
- After discovering and fixing bugs
- After making architectural decisions
- After adding or changing technologies
- After encountering and resolving issues

**Required Format:**
See [System Log Entry Template](../templates/system-log-entry-template.md)

**Minimum Contents:**

- Timestamp (UTC)
- Summary of change
- Affected files (complete list)
- Rationale for approach
- Chain of Reasoning (Observation → Hypothesis → Action)
- Verification steps taken

**Example Entry:**

```markdown
## 2026-03-19 14:32 UTC - Fixed Database Connection Issue

**Summary:** Resolved PostgreSQL connection failures by correcting hostname in connection string.

**Affected Files:**
- `docker-compose.yml` (line 23)
- `.env` (DATABASE_HOST variable)

**Chain of Reasoning:**
- Observation: Application failing with "connection refused" on port 5432
- Hypothesis: Initially suspected port misconfiguration. After 2 failed attempts (loop detected), re-analyzed and discovered hostname was 'localhost' instead of container name 'postgres'
- Action: Updated DATABASE_HOST from 'localhost' to 'postgres'

**Verification:**
- Application now connects successfully
- No errors in application logs
- Database queries executing normally

**Confidence:** 95% - Verified through successful connection testing.
```

---

### 2. PORTS.md

**Purpose:** Authoritative ledger of all port assignments across all services.

**When to Update:**

- Before assigning a new port to any service
- After changing a service's port
- After removing a service

**Required Format:**

```markdown
| Port | Service | Purpose | Status |
|------|---------|---------|--------|
| 3000 | frontend | React dev server | Active |
| 5432 | postgres | Database | Active |
| 6379 | redis | Cache | Active |
| 8080 | api | REST API | Active |
```

**Rules:**

- ALWAYS read PORTS.md before assigning a port
- NEVER assume a port is available
- Document port ranges for service groups
- Mark decommissioned services as "Deprecated" (don't delete immediately)

---

### 3. Project_Context.md

**Purpose:** High-level architecture map showing service relationships and dependencies.

**When to Update:**

- After adding a new service
- After changing service relationships
- After modifying authentication/authorization flow
- After changing data flow between services

**Required Contents:**

- Service inventory (what exists)
- Service relationships (what depends on what)
- Data flow diagrams (how data moves)
- Authentication/authorization model
- External dependencies (third-party APIs, etc.)

---

## Code Documentation Standards

### Inline Comments: The "Why", Not the "What"

**Bad (documents what the code does):**

```python
# Loop through users
for user in users:
    # Send email
    send_email(user.email)
```

**Good (documents why/business logic):**

```python
# Send password reset emails only to users who requested them in the last 24 hours
# to prevent abuse and comply with GDPR data minimization
for user in users_with_recent_requests:
    send_password_reset_email(user.email)
```

---

### Function/Method Documentation

**Required for ALL public functions:**

```python
def normalize_score(value: float, min_val: float, max_val: float) -> float:
    """
    Normalize a value to the range [0, 1].

    Used for PC2E scoring to convert raw metrics into comparable scores.

    Args:
        value: The value to normalize
        min_val: Minimum possible value
        max_val: Maximum possible value

    Returns:
        Normalized value in range [0, 1]

    Raises:
        ValueError: If min_val == max_val (division by zero)

    Example:
        >>> normalize_score(50, 0, 100)
        0.5
    """
    if min_val == max_val:
        raise ValueError("min_val and max_val cannot be equal")
    return (value - min_val) / (max_val - min_val)
```

---

### Complex Logic Documentation

**For any logic that requires more than 30 seconds to understand:**

```python
# PC2E 5-Gate Multiplicative Scoring
# Each gate returns 0 (fail) or 1 (pass)
# Final score = p_regex * p_nums * p_logic * p_subset * p_omission
#
# If ANY gate fails (returns 0), the entire score collapses to 0
# This ensures deterministic rejection rather than probabilistic scoring
score = (
    regex_gate *
    numerical_gate *
    logic_gate *
    subset_gate *
    omission_gate
)
```

---

## Technology Decision Documentation

### Tech Decision Records (TDR)

**Required for EVERY new technology, library, or framework.**

See [TDR Template](../templates/tdr-template.md) for the standard format.

**Minimum Contents:**

- What problem does this technology solve?
- What alternatives were considered?
- Why were alternatives rejected?
- Compatibility score (1-10)
- Maintainability score (1-10)
- Maintenance status (Active/Maintenance-only/Deprecated)
- Version being used (pinned, not "latest")

**Threshold:** Do NOT use any technology scoring below 7/10 on EITHER metric without explicit user approval.

---

## Documentation Timing

### ❌ BAD: "I'll document it later"

Documentation drift is a form of technical debt. By the time "later" arrives:

- You've forgotten the reasoning
- Context has changed
- The documentation never gets written

### ✅ GOOD: Document immediately

**The Rule:** Documentation is part of the implementation, not a separate task.

**Process:**

1. Make the change
2. Test the change
3. Document the change in SYSTEM_LOG.md
4. Update Project_Context.md (if architecture changed)
5. Update PORTS.md (if ports changed)
6. THEN and only then, task is complete

---

## README Files

### When to Create a README

**Create a README when:**

- Starting a new project or service
- Creating a new module with multiple files
- Building a reusable component/library

**Do NOT create a README for:**

- Single-file utilities (document in the file itself)
- Temporary experimental code
- Proof-of-concept code that won't be maintained

### README Contents

**Minimum sections:**

```markdown
# [Project Name]

## Purpose
What does this do? Why does it exist?

## Quick Start
How do I run this? (Commands, prerequisites)

## Architecture
High-level overview of how this works

## Configuration
Environment variables, config files, settings

## Dependencies
What does this require to run?

## Troubleshooting
Common issues and solutions

## Maintenance
Who maintains this? How to contribute?
```

---

## API Documentation

### For All HTTP Endpoints

```python
@app.route('/api/users/<user_id>', methods=['GET'])
def get_user(user_id):
    """
    Get user details by ID.

    **Endpoint:** GET /api/users/<user_id>

    **Authentication:** Required (JWT token)

    **Authorization:** User can only access their own data unless admin role

    **Parameters:**
        user_id (int): User ID (path parameter)

    **Returns:**
        200: User object
        {
            "id": 123,
            "email": "user@example.com",
            "created_at": "2026-01-01T00:00:00Z"
        }

        404: User not found
        {
            "error": "User not found"
        }

        403: Forbidden (attempting to access another user's data)
        {
            "error": "Forbidden"
        }

    **Example:**
        curl -H "Authorization: Bearer <token>" https://api.example.com/api/users/123
    """
    # Implementation...
```

---

## Documentation Anti-Patterns

### ❌ Anti-Pattern 1: Outdated Documentation

**Problem:** Documentation that contradicts the actual code.

**Worse than no documentation** because it actively misleads.

**Solution:** Update documentation AT THE SAME TIME as code changes.

---

### ❌ Anti-Pattern 2: Obvious Comments

```python
# Increment counter
counter += 1
```

**Problem:** Wastes space, provides no value.

**Solution:** Only comment when explaining non-obvious logic.

---

### ❌ Anti-Pattern 3: TODO Without Tracking

```python
# TODO: Optimize this function
def slow_function():
    ...
```

**Problem:** TODOs are invisible and get forgotten.

**Solution:** Every TODO MUST have a corresponding SYSTEM_LOG.md entry with timeline.

---

### ❌ Anti-Pattern 4: "See Code" Documentation

```markdown
## How It Works
See the code.
```

**Problem:** Defeats the purpose of documentation.

**Solution:** Explain the high-level logic, architecture, and business rules. Code shows implementation; documentation explains intent.

---

## Explainability Standard (PC2E Mandate)

Rather than just logging "what" was changed, you MUST log the **Chain of Reasoning (CoR)**.

When documenting a complex fix or architectural shift, structure your logic as:

```text
Observation → Hypothesis → Action
```

**Example:**

```markdown
## Database Performance Optimization

**Observation:** Query response times increased from 50ms to 2000ms over 3 months.

**Hypothesis:** Missing indexes on frequently queried columns (user_id, created_at). Verified by running EXPLAIN on slow queries.

**Action:** Added composite index on (user_id, created_at). Tested with production-equivalent dataset.

**Result:** Query response times reduced to 45ms (10% improvement over original).

**Confidence:** 95% - Verified through load testing with 10,000 concurrent requests.
```

---

## Documentation Checklist

Before declaring any task complete, verify:

- [ ] SYSTEM_LOG.md updated with change details
- [ ] PORTS.md updated (if ports changed)
- [ ] Project_Context.md updated (if architecture changed)
- [ ] Code comments added for complex logic
- [ ] Function/method docstrings added
- [ ] README updated (if project-level changes)
- [ ] API documentation updated (if endpoints changed)
- [ ] TDR created (if new technology added)
- [ ] Chain of Reasoning documented
- [ ] All documentation is current (no contradictions with code)

---

## Enforcement

**Documentation is non-negotiable.** Tasks without proper documentation are incomplete.

Violations result in:

- Task marked as incomplete
- Mandatory documentation before proceeding
- Logged incident in SYSTEM_LOG.md

**Remember:** Future you (and other developers) will thank present you for good documentation.

---

## SYSTEM_LOG.md — Monitoring and Maintenance

### Session Tagging

Every SYSTEM_LOG.md entry MUST begin with a session identifier to enable tracing of
all decisions made within a single agent session:

```markdown
## [SESSION: GOV-YYYY-MM-DD-XXXX] — <brief description>
```

The session ID format: `GOV-` + date + `-` + 4-character alphanumeric suffix.
Generate the suffix from the first task of the session. Keep it consistent across
all entries from the same session.

### Standard Log Queries

Use these commands to inspect and monitor SYSTEM_LOG.md:

```bash
# View the last 20 entries
tail -n 100 SYSTEM_LOG.md

# Find all entries from a specific session
grep -A 20 "SESSION: GOV-2026-05-15" SYSTEM_LOG.md

# Find all HITL decisions
grep -A 5 "HITL" SYSTEM_LOG.md

# Find all security-related entries
grep -A 10 "security\|canary\|PII\|injection\|breach" SYSTEM_LOG.md -i

# Find all entries with LOW confidence
grep -B 2 "LOW_CONFIDENCE\|confidence.*0\.[0-6]" SYSTEM_LOG.md -i

# Count entries by month
grep "^## \[SESSION:" SYSTEM_LOG.md | grep -o "GOV-[0-9-]*" | cut -d- -f2,3 | sort | uniq -c
```

### Anomaly Patterns to Review

Review SYSTEM_LOG.md when you see any of the following patterns:

| Pattern | Action |
| --- | --- |
| Multiple consecutive LOW_CONFIDENCE entries | Governance context may not be loaded correctly — verify deployment |
| HITL gate bypassed (no log entry for a destructive operation) | Investigate immediately — this is a compliance violation |
| Canary token string in any log entry | Treat as security incident — rotate credentials |
| Session produces no SYSTEM_LOG.md entries | Agent may be operating outside governance — review session |
| Entries referencing PII values | Immediate redaction required — review masking process |

### Log Rotation Policy

- Entries remain in SYSTEM_LOG.md for **90 days** from the entry date
- After 90 days: move to `SYSTEM_LOG_ARCHIVE.md` (create if it doesn't exist)
- Archive format: same as SYSTEM_LOG.md, prefixed with `[ARCHIVED YYYY-MM-DD]`
- Archives are retained for **1 year** from the archive date, then deleted
- Never delete entries that relate to unresolved security incidents

Rotation command:

```bash
# Manually archive entries older than 90 days (run monthly)
CUTOFF=$(date -d "90 days ago" "+%Y-%m-%d")
echo "Archiving entries before $CUTOFF from SYSTEM_LOG.md"
# Manual process: move sessions with dates < CUTOFF to SYSTEM_LOG_ARCHIVE.md
```
