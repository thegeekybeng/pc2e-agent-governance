# System Log Entry Template

---
last_updated: 2026-03-19
pc2e_version: 1.0
---

> Use this template for all entries in SYSTEM_LOG.md. Consistency enables easy searching and auditing.

---

## Standard Entry Format

```markdown
## [YYYY-MM-DD HH:MM UTC] - [Brief Summary]

**Type:** [Implementation | Bug Fix | Architecture Change | Configuration | Documentation | Incident]

**Affected Files:**
- `file1.path` (lines X-Y)
- `file2.path` (new file)
- `file3.path` (deleted)

**Chain of Reasoning:**
- **Observation:** [What was observed/detected/measured?]
- **Hypothesis:** [What root cause or approach was hypothesized?]
- **Action:** [What specific changes were made?]

**Result:**
[What was the outcome? How was it verified?]

**Confidence:** [XX]% - [Reasoning for confidence level]

**Related:**
- [Link to Issue #XX]
- [Link to PR #XX]
- [Reference to previous log entry: YYYY-MM-DD]

---
```

---

## Example Entries

### Example 1: Implementation

```markdown
## 2026-03-19 14:32 UTC - Implemented User Authentication with JWT

**Type:** Implementation

**Affected Files:**
- `backend/auth/jwt_handler.py` (new file)
- `backend/api/middleware.py` (lines 15-45)
- `backend/models/user.py` (lines 23-28)
- `requirements.txt` (added PyJWT==2.8.0)
- `docker-compose.yml` (lines 34-36, added JWT_SECRET env var)

**Chain of Reasoning:**
- **Observation:** Application needs secure, stateless authentication for API endpoints
- **Hypothesis:** JWT tokens provide stateless authentication suitable for horizontal scaling
- **Action:**
  1. Created JWT handler with HS256 signing
  2. Implemented middleware to validate tokens on protected routes
  3. Added user_id claim to JWT payload
  4. Set token expiration to 24 hours

**Result:**
- Successfully authenticating users
- Tokens expire as configured
- Protected endpoints reject invalid tokens
- Load tested with 1000 concurrent requests - no issues

**Confidence:** 95% - Verified through unit tests and load testing

**Related:**
- TDR: Tech Decision: PyJWT (see entry 2026-03-15)
- [Issue #42](...)

---
```

---

### Example 2: Bug Fix

```markdown
## 2026-03-18 09:15 UTC - Fixed Database Connection Pool Exhaustion

**Type:** Bug Fix

**Affected Files:**
- `backend/database.py` (lines 12-18)
- `backend/config.py` (lines 45-47)

**Chain of Reasoning:**
- **Observation:** Application throwing "connection pool exhausted" errors after 2 hours of operation. Logs showed 100 connections opened, none closed.
- **Hypothesis:** Connection pooling not configured correctly; connections not being returned to pool after use.
- **Action:**
  1. Added explicit connection pool configuration (pool_size=20, max_overflow=10)
  2. Implemented context managers to ensure connections always returned
  3. Added connection pool monitoring

**Result:**
- No pool exhaustion after 24 hours of operation
- Peak connections: 18 (within pool_size limit)
- Average response time improved from 250ms to 180ms (fewer connection creation overhead)

**Confidence:** 98% - Verified through 24-hour stress test

**Related:**
- Incident: 2026-03-18 08:00 UTC (production outage)
- Similar issue resolved: 2026-02-10 (different root cause)

---
```

---

### Example 3: Architecture Change

```markdown
## 2026-03-17 16:45 UTC - Migrated from Monolith to Microservices (Phase 1: Auth Service)

**Type:** Architecture Change

**Affected Files:**
- `services/auth/` (new directory, 15 files)
- `docker-compose.yml` (lines 50-75, new auth service)
- `backend/api/routes.py` (lines 23-45, removed auth routes)
- `PORTS.md` (added port 8001 for auth service)
- `Project_Context.md` (updated architecture diagram)

**Chain of Reasoning:**
- **Observation:** Monolithic application becoming difficult to scale; auth-related changes requiring full application restart
- **Hypothesis:** Extracting authentication into separate microservice will enable:
  1. Independent scaling of auth workload
  2. Faster deployment cycles (auth changes don't require full app restart)
  3. Better separation of concerns
- **Action:**
  1. Created new FastAPI service for authentication
  2. Moved JWT handling, user management to auth service
  3. Updated main application to call auth service via internal API
  4. Implemented service-to-service authentication

**Result:**
- Auth service deployed and handling 100% of authentication requests
- Main application restart time reduced from 45s to 15s (smaller codebase)
- Auth service can now be scaled independently
- No functionality regressions detected

**Confidence:** 85% - Production deployment successful, but long-term maintainability unproven

**Related:**
- Architecture RFC: Microservices Migration Plan (2026-03-01)
- Next Phase: Payment Service extraction (planned 2026-04-01)

---
```

---

### Example 4: Configuration Change

```markdown
## 2026-03-16 11:20 UTC - Increased Nginx Worker Processes for Better Concurrency

**Type:** Configuration

**Affected Files:**
- `nginx/nginx.conf` (line 5)

**Chain of Reasoning:**
- **Observation:** CPU utilization consistently at 25% (1 of 4 cores used). Nginx using single worker process.
- **Hypothesis:** Nginx configured with 1 worker process, unable to leverage multi-core CPU.
- **Action:** Changed `worker_processes` from `1` to `auto` (matches CPU core count)

**Result:**
- Nginx now using 4 worker processes (1 per core)
- CPU utilization distributed across all cores
- Request throughput increased from 500 req/s to 1800 req/s
- Average response time reduced from 120ms to 85ms

**Confidence:** 99% - Verified through load testing with ApacheBench

**Related:**
- Performance audit: 2026-03-15

---
```

---

### Example 5: Incident Post-Mortem

```markdown
## 2026-03-15 22:30 UTC - POST-MORTEM: 2-Hour Production Outage (Database Crash)

**Type:** Incident

**Affected Files:**
- None (configuration issue, not code)

**Chain of Reasoning:**
- **Observation:** Database crashed at 20:15 UTC with "out of memory" error. All services became unavailable.
- **Hypothesis:** Memory leak in database or misconfigured memory limits.
- **Action:**
  1. Immediate: Restarted database container (service restored 20:22 UTC)
  2. Investigation: Analyzed container resource usage over past week
  3. Root Cause: Database `shared_buffers` set to 8GB, but container limited to 4GB RAM
  4. Fix: Reduced `shared_buffers` to 1GB, increased container memory limit to 8GB

**Result:**
- Database stable for 48+ hours post-fix
- Memory usage: 3.5GB peak (well within 8GB limit)
- No performance degradation from reduced shared_buffers

**Confidence:** 95% - Root cause confirmed through config mismatch

**Timeline:**
- 20:15 UTC: Database crash detected
- 20:18 UTC: Incident declared, on-call alerted
- 20:22 UTC: Database restarted, service restored
- 20:30-22:00 UTC: Root cause investigation
- 22:15 UTC: Configuration fix deployed
- 22:30 UTC: Incident closed

**Impact:**
- Duration: 2 hours (partial: 7 minutes full outage, 113 minutes degraded)
- Affected users: ~500 active users
- Lost requests: ~3,000 (error rate: 100% during full outage)

**Prevention:**
- [ ] Add memory usage alerts (threshold: 80%)
- [ ] Implement automated config validation (container limits vs app config)
- [ ] Document resource sizing guidelines in Project_Context.md

**Related:**
- Incident: 2026-02-20 (similar memory issue, different service)

---
```

---

## Quick Reference

### Entry Types

| Type | When to Use |
|------|-------------|
| **Implementation** | New feature, new component, or new capability |
| **Bug Fix** | Resolving a defect or incorrect behavior |
| **Architecture Change** | Structural changes to system design |
| **Configuration** | Changes to settings, environment variables, or deployment config |
| **Documentation** | Updates to docs, comments, or README files |
| **Incident** | Post-mortem for outages or production issues |

---

## Best Practices

### DO:
✅ Log immediately after completing the change
✅ Include all affected files with line numbers
✅ Use Chain of Reasoning (Observation → Hypothesis → Action)
✅ State confidence level with reasoning
✅ Link to related entries or issues
✅ Timestamp in UTC

### DON'T:
❌ Batch multiple unrelated changes into one entry
❌ Omit the "why" (rationale for the change)
❌ Skip verification results
❌ Use vague descriptions ("fixed stuff")
❌ Forget to update PORTS.md or Project_Context.md when relevant

---

## Searchability

Use consistent keywords for easy searching:

- **Security:** `SECURITY`, `CVE`, `vulnerability`, `authentication`, `authorization`
- **Performance:** `PERFORMANCE`, `optimization`, `load test`, `throughput`, `latency`
- **Database:** `DATABASE`, `migration`, `schema change`, `query optimization`
- **Breaking Change:** `BREAKING CHANGE`, `API change`, `migration required`
- **Rollback:** `ROLLBACK`, `reverted`, `undone`

**Example:**
```markdown
## 2026-03-14 10:00 UTC - SECURITY: Patched SQL Injection Vulnerability

**Type:** Bug Fix (SECURITY, CVE-2024-XXXXX)
...
```

---

## Maintenance

### Archive Old Entries

Once SYSTEM_LOG.md exceeds 10,000 lines:
1. Create `SYSTEM_LOG_ARCHIVE_YYYY.md`
2. Move entries older than 12 months to archive
3. Keep recent entries in main SYSTEM_LOG.md
4. Update index/table of contents

### Regular Reviews

**Monthly:** Review last month's entries for patterns (recurring issues, frequent changes)
**Quarterly:** Identify technical debt introduced and schedule cleanup
**Yearly:** Archive old entries, update documentation

---

This template ensures all SYSTEM_LOG.md entries are consistent, searchable, and provide complete context for future developers.
