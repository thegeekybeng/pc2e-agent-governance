---
trigger: reference
last_updated: 2026-05-15
pc2e_version: 1.0
---

# Merge Checklist — PC2E Governance Changes

> This checklist MUST be completed before merging any PR that modifies files in this
> repository. Items marked `[BLOCK]` prevent merge until resolved. Items marked `[WARN]`
> must be reviewed and either resolved or explicitly accepted by the framework owner.

---

## How to Use This Checklist

1. Copy this checklist into the PR description
2. Check off each item as you verify it
3. All `[BLOCK]` items MUST be checked before requesting review
4. Tag the framework owner (@thegeekybeng) for `[WARN]` items that cannot be resolved

---

## [BLOCK] — Must pass before merge

### Lint and Format

- [ ] `markdownlint` passes on all changed `.md` files with zero warnings
- [ ] YAML frontmatter on all changed files has `last_updated` set to today's date
- [ ] No MD036 (bold-as-heading) violations in changed files
- [ ] No MD032 (list without surrounding blank lines) violations in changed files

### Rule Integrity

- [ ] No rule in `global/` contradicts an existing global rule
- [ ] No mode file introduces a rule that weakens a global mandate
- [ ] If a rule was removed or weakened, a TDR documents the decision with rationale
- [ ] OWASP LLM Top 10 table in README.md is updated if a mitigation status changed

### Documentation

- [ ] `SYSTEM_LOG.md` updated with: what changed, why, which files were affected
- [ ] Every new file is referenced by at least one other file (no orphaned documents)
- [ ] If a new global file was added, it is linked from `governance-framework.md`
- [ ] If a new template was added, it is linked from `README.md` Documentation section

### Security

- [ ] No secrets, credentials, or PII introduced into any file
- [ ] If a security control was modified, `SECURITY_AUDIT.md` coverage matrix is updated
- [ ] `.env` files are not tracked (verify: `git status` shows no `.env*` files staged)

---

## [WARN] — Review required

### Governance Impact

- [ ] If a `global/` file was changed: all 5 mode files remain consistent with the update
- [ ] If a mode file was changed: all 5 modes remain internally consistent
- [ ] If a workflow was added or changed: `README.md` Workflows section reflects it
- [ ] If a template was changed: existing projects using the template are notified

### Security Regression Check

- [ ] Verify each ✅ row in `SECURITY_AUDIT.md` is still satisfied after this change
- [ ] If any ✅ row would regress to ⚠️ or ❌, this is a `[BLOCK]` — reclassify

### Scalability

- [ ] If new content was added to a global file: review token budget impact
  (global files total must remain navigable within a 32K context window)
- [ ] If a new file was added to `global/`: update `token-optimisation.md` load order

### Versioning

- [ ] If this is a breaking change (rule removed, mandate weakened):
  - Version bump required (e.g., v1.0 → v1.1)
  - `CHANGELOG.md` updated with the change
  - Consuming projects notified via release notes

---

## Sign-off

| Role | Name | Date |
| --- | --- | --- |
| Author | | |
| Reviewer (framework owner) | | |

---

*Template version: 2026-05-15*
*Apply this checklist to every PR — no exceptions.*
