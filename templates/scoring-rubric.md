---
last_updated: 2026-05-15
pc2e_version: 1.0
trigger: always_on
---

# Technology Scoring Rubric


> This rubric provides objective criteria for evaluating technologies, libraries, and frameworks.

---

## Overview

Every technology decision MUST be scored on two dimensions:

1. **Compatibility** (1-10): How well does it integrate with our existing stack?
2. **Maintainability** (1-10): How sustainable is it for long-term use?

**Threshold:** Do NOT use any technology scoring below 5 on EITHER metric without explicit user approval.

---

## Compatibility Score (1-10)

**Definition:** How easily does this technology integrate with our existing architecture, languages, and tools?

### 10/10 - Perfect Compatibility

- Native integration with no configuration required
- Zero conflicts with existing dependencies
- Widely adopted across the industry (proven interoperability)
- Standard protocol/interface (e.g., SQL, REST, OpenAPI)
- Examples: PostgreSQL for Python projects, Redis for caching, Docker for deployment

### 9/10 - Excellent Compatibility

- Works seamlessly with minor configuration (5-10 lines)
- Well-documented integration guides exist
- Popular in the ecosystem (npm/PyPI downloads > 1M/month)
- Examples: FastAPI for Python APIs, React for frontend, Nginx for reverse proxy

### 8/10 - Very Good Compatibility

- Requires moderate configuration (10-30 lines)
- Good community support for integration
- Established patterns exist
- Examples: Kafka for event streaming, Elasticsearch for search

### 7/10 - Good Compatibility

- Requires notable configuration effort (30-100 lines)
- Integration is well-documented but not trivial
- Some quirks or edge cases to handle
- Examples: GraphQL implementations, some ORMs

### 6/10 - Acceptable Compatibility

- Requires significant configuration (100+ lines)
- Integration documentation is sparse
- May need custom adapters or glue code
- Examples: Legacy system integrations, niche databases

### 5/10 - Marginal Compatibility

- Requires substantial adaptation work
- Potential for version conflicts
- Limited community examples
- Consider alternatives before proceeding

### 4/10 and below - Poor Compatibility

- Major incompatibilities with existing stack
- Requires architectural changes to accommodate
- High risk of version conflicts
- **DO NOT USE** without explicit user approval

---

## Maintainability Score (1-10)

**Definition:** How sustainable is this technology for long-term use and maintenance?

### 10/10 - Exceptional Maintainability

- Active development with frequent releases (monthly or better)
- Large, healthy community (GitHub stars > 20k)
- Excellent documentation (official docs + tutorials + examples)
- Backed by reputable organization (e.g., HashiCorp, Apache Foundation)
- Long-term support (LTS) versions available
- Examples: Kubernetes, PostgreSQL, Node.js LTS

### 9/10 - Excellent Maintainability

- Active development with regular releases (quarterly)
- Strong community (GitHub stars > 10k)
- Good documentation and active discussions
- Proven stability in production
- Examples: FastAPI, Redis, Nginx

### 8/10 - Very Good Maintainability

- Regular updates (1-2 times per year)
- Moderate community (GitHub stars > 5k)
- Decent documentation with some gaps
- Stable API with clear deprecation policies
- Examples: Many popular npm/PyPI packages

### 7/10 - Good Maintainability

- Periodic updates (yearly)
- Small but active community
- Documentation exists but may be incomplete
- Stable but slow to adopt new features
- Examples: Mature, niche libraries

### 6/10 - Acceptable Maintainability

- Infrequent updates (1-2 years between releases)
- Small community or single maintainer
- Documentation is minimal or outdated
- API stability uncertain
- **Requires monitoring** for security updates

### 5/10 - Marginal Maintainability

- Maintenance-mode only (bug fixes, no new features)
- Very small community
- Documentation is poor or non-existent
- Consider migration timeline

### 4/10 and below - Poor Maintainability

- No recent updates (2+ years)
- Abandoned or deprecated
- No community support
- **DO NOT USE** without explicit user approval and migration plan

---

## Combined Scoring Matrix

| Compatibility | Maintainability | Decision |
| :---: | :---: | --- |
| 9-10 | 9-10 | ✅ **Ideal** - Proceed with confidence |
| 8-9 | 7-9 | ✅ **Excellent** - Good choice |
| 7-8 | 7-8 | ✅ **Good** - Acceptable with awareness of trade-offs |
| 6-7 | 6-7 | ⚠️ **Caution** - Document risks and mitigation |
| 5-6 | 5-6 | ⚠️ **Risky** - Requires explicit justification |
| <5 | Any | ❌ **Reject** - Find alternative |
| Any | <5 | ❌ **Reject** - Find alternative |

---

## Special Considerations

### Emerging Technologies (< 2 years old)

**Apply penalty:**

- Reduce Maintainability score by 1-2 points
- Uncertain long-term viability
- API may change significantly

**Exception:** If backed by major organization (Google, Meta, Microsoft) and shows rapid adoption, penalty may be waived.

### Security-Critical Components

**Require higher threshold:**

- Minimum 7/10 on both dimensions
- Must have active security patch history
- Must have clear vulnerability disclosure process

**Examples:** Authentication libraries, encryption tools, network security components

### Data Storage Technologies

**Require higher maintainability:**

- Minimum 8/10 on Maintainability (data longevity critical)
- Must have clear backup/restore procedures
- Must have proven upgrade path

**Examples:** Databases, file systems, object storage

---

## Evaluation Checklist

When scoring a technology, consider:

### Compatibility Evaluation

- [ ] Tested integration with our stack
- [ ] Version conflicts checked
- [ ] Configuration complexity assessed
- [ ] Community examples reviewed
- [ ] Performance benchmarks reviewed

### Maintainability Evaluation

- [ ] Release history reviewed (frequency, cadence)
- [ ] Community size measured (GitHub stars, npm downloads, etc.)
- [ ] Documentation quality assessed
- [ ] Issue response time checked
- [ ] Long-term roadmap exists
- [ ] Known vulnerabilities checked (CVE database)
- [ ] License reviewed (compatibility with our needs)
- [ ] Bus factor assessed (single maintainer vs team)

---

## Scoring Examples

### Example 1: TypeScript

#### Compatibility Score: 10/10

- Native JavaScript superset (perfect integration)
- Works with all Node.js tools
- Industry standard for large-scale JS projects
- Zero conflicts with existing dependencies

#### Maintainability Score: 10/10

- Backed by Microsoft (long-term support guaranteed)
- Monthly releases with clear roadmap
- Massive community (GitHub stars > 90k)
- Excellent documentation
- LTS versions available

**Decision:** ✅ **Ideal** - Proceed with confidence

---

### Example 2: Older ORM Library (Hypothetical)

#### Compatibility Score: 7/10

- Works with Python 3.9+
- Requires custom migrations for some data types
- Integration documentation exists but is dated
- Some quirks with async support

#### Maintainability Score: 5/10

- Last release 18 months ago
- Single maintainer (bus factor = 1)
- Documentation hasn't been updated in 2 years
- Small community (GitHub stars < 1k)
- Maintenance-mode only (no new features)

**Decision:** ⚠️ **Risky** - Requires explicit justification and migration timeline

**Recommendation:** Find alternative (e.g., SQLAlchemy, Prisma) with better maintainability score.

---

### Example 3: Experimental AI Library (Hypothetical)

#### Compatibility Score: 6/10

- Requires specific Python 3.11
- Some conflicts with existing data processing libraries
- Documentation is incomplete
- Limited community examples

#### Maintainability Score: 4/10

- Released 6 months ago (very new)
- Unclear roadmap
- Academic project (single university lab)
- Documentation is research paper quality (not production-ready)
- Unknown long-term support commitment

**Decision:** ❌ **Reject** - Find alternative

**Rationale:** Maintainability < 5 threshold. Too risky for production use.

---

## Updating Scores Over Time

Technology scores can change. Re-evaluate when:

- Major version release occurs
- Ownership/maintainer changes
- Security vulnerability discovered
- Industry adoption shifts
- Competing technology emerges
- 6 months have passed since last evaluation

**Process:**

1. Re-score using this rubric
2. Update TDR in SYSTEM_LOG.md
3. If score drops below threshold, create migration plan

---

## Special Cases

### Legacy Code Integration

When integrating with legacy systems that score poorly:

**Approach:**

- Create abstraction layer (adapter pattern)
- Isolate legacy dependency
- Document risks in TDR
- Create migration roadmap
- Set review date (6-12 months)

**Example:**

```text
Legacy System: Proprietary Database (Compatibility: 4/10, Maintainability: 3/10)

Solution: Create database abstraction layer
- Isolates proprietary DB behind standard interface
- Allows migration to PostgreSQL without rewriting business logic
- Migration timeline: 12 months
- Review: Quarterly
```

---

## Confidence Calibration (PC2E Integration)

When scoring, state your confidence:

**Example:**

```text
Compatibility Score: 8/10 (Confidence: 90%)
- Based on: Official docs, community examples, personal testing
- Uncertainty: Performance at scale (not tested with our dataset size)

Maintainability Score: 9/10 (Confidence: 95%)
- Based on: Release history, community size, GitHub activity
- Uncertainty: None (objective metrics)
```

If confidence < 80% on either score, **escalate for further research** before proceeding.

---

## Summary

**Remember the threshold:** Do NOT use any technology scoring below **5/10** on EITHER metric without explicit user approval.

**When in doubt:** Choose the technology with the higher combined score, favoring Maintainability for long-lived systems and Compatibility for rapid prototyping.

**Always document:** Every technology decision MUST have a TDR with scores justified using this rubric.
