---
trigger: always_on
last_updated: 2026-03-19
pc2e_version: 1.0
---

# Anti-Regression Rules


> These rules prevent the introduction of bugs, workarounds, and technical debt that cause previously working functionality to break.

---

## Core Principles

### Principle 1: Fix Root Causes, Not Symptoms

**Never mask errors.** Find and eliminate the underlying cause.

**Forbidden Patterns:**
- Wrapping errors in try/catch without fixing the bug
- Adding timeouts to "work around" race conditions
- Disabling security checks to make tests pass
- Catch-all exception handlers that hide failures

**Required Pattern:**
```text
Observation → Root Cause Analysis → Proper Fix → Verification
```

---

### Principle 2: Read Before Modifying

**Never modify a file without reading it first** — even if you "know" what's in it from earlier in the session.

**Why:**
- Files may have changed
- Memory from earlier in session may be inaccurate
- Assumptions lead to breaking existing functionality

**Required:**
- Use the Read tool on every file before editing
- Verify current state matches assumptions
- Check for dependencies that might break

---

### Principle 3: Never Silence Errors

**If you feel tempted to wrap something in a catch-all, the error is telling you something important.**

**Forbidden:**
```python
try:
    critical_operation()
except:
    pass  # Silent failure
```

**Required:**
```python
try:
    critical_operation()
except SpecificException as e:
    logger.error(f"Critical operation failed: {e}")
    # Handle the specific failure case
    raise  # Re-raise if cannot be handled
```

---

## Implementation Standards

### No Workarounds Without Justification

> **A workaround that will need to be "cleaned up later" is technical debt in disguise.**

**Before implementing a workaround, ask:**
1. Why can't I fix this properly right now?
2. What is blocking the proper fix?
3. How much time would the proper fix take?
4. What is the cost of the workaround (maintenance, confusion, brittleness)?

**If you must use a workaround:**
1. Document it in `SYSTEM_LOG.md` with:
   - Why the workaround was necessary
   - What the proper fix would be
   - Timeline for implementing the proper fix
   - Risks introduced by the workaround
2. Add a TODO comment in the code linking to the SYSTEM_LOG.md entry
3. Set a calendar reminder for the proper fix

---

### One Change at a Time

**Make ONE change, test it, verify the result. Do NOT make multiple changes simultaneously.**

**Why:**
- Multiple simultaneous changes make debugging impossible
- Cannot isolate which change caused a regression
- Violates scientific method (change one variable at a time)

**Required Process:**
1. Make a single logical change
2. Test the change
3. Verify no regressions
4. Commit (if using version control)
5. Repeat for next change

---

### Verify, Don't Assume

**Never assume a change worked. Always verify.**

**Verification Checklist:**
- [ ] Run the specific functionality that was changed
- [ ] Run tests for related functionality (regression testing)
- [ ] Check terminal output for warnings or errors
- [ ] Verify no new error messages in logs
- [ ] Confirm performance hasn't degraded

**Example:**
```bash
# Don't just run the command
docker-compose up -d

# Read the output and verify success
docker-compose up -d
docker ps  # Verify containers are running
docker logs <container>  # Check for errors
```

---

## Anti-Patterns to Avoid

### ❌ Anti-Pattern 1: The "Quick Fix"

**Scenario:** Under time pressure, implementing a hack instead of the proper solution.

**Example:**
```python
# Quick fix: hardcode the value
API_KEY = "sk-1234567890abcdef"
```

**Why it's wrong:**
- Creates security vulnerability
- Makes code non-portable
- Requires manual updates
- Will be forgotten and cause production incidents

**Proper Fix:**
```python
# Proper fix: use environment variables
API_KEY = os.getenv("API_KEY")
if not API_KEY:
    raise ValueError("API_KEY environment variable not set")
```

---

### ❌ Anti-Pattern 2: The Silent Fail

**Scenario:** Catching exceptions without handling them properly.

**Example:**
```python
def save_data(data):
    try:
        database.insert(data)
    except Exception:
        return  # Data not saved, but no indication of failure
```

**Why it's wrong:**
- Hides critical failures
- Makes debugging impossible
- Data loss is invisible
- Violates principle of explicit error handling

**Proper Fix:**
```python
def save_data(data):
    try:
        database.insert(data)
    except DatabaseConnectionError as e:
        logger.error(f"Failed to save data: {e}")
        raise  # Re-raise to alert calling code
    except ValidationError as e:
        logger.warning(f"Invalid data: {e}")
        return False  # Return explicit failure indicator
    return True  # Return explicit success indicator
```

---

### ❌ Anti-Pattern 3: The Copy-Paste

**Scenario:** Duplicating code instead of abstracting into a reusable function.

**Example:**
```python
# In file1.py
result = (value - min_value) / (max_value - min_value)

# In file2.py
result = (value - min_value) / (max_value - min_value)

# In file3.py
result = (value - min_value) / (max_value - min_value)
```

**Why it's wrong:**
- Bug fixes must be applied in multiple places
- Inconsistencies creep in over time
- Violates DRY (Don't Repeat Yourself)
- Maintenance nightmare

**Proper Fix:**
```python
# In utils.py
def normalize(value, min_value, max_value):
    """Normalize value to range [0, 1]."""
    if max_value == min_value:
        raise ValueError("min_value and max_value cannot be equal")
    return (value - min_value) / (max_value - min_value)

# In all files
result = normalize(value, min_value, max_value)
```

---

### ❌ Anti-Pattern 4: The Untested Change

**Scenario:** Modifying code without verifying it still works.

**Example:**
```text
Developer: "I updated the database connection string."
[Deploys to production]
[Everything breaks because connection string is wrong]
```

**Why it's wrong:**
- Preventable failures reach production
- No verification before deployment
- Assumes changes work without evidence

**Proper Fix:**
```text
1. Update the database connection string
2. Run connection test: `python test_connection.py`
3. Verify successful connection in output
4. Run full test suite
5. Verify all tests pass
6. THEN deploy
```

---

## Regression Prevention Checklist

Before declaring any task complete, verify:

- [ ] **No functionality was broken** - Run tests for affected areas
- [ ] **No new warnings or errors** - Check terminal output and logs
- [ ] **No performance degradation** - Verify response times are similar
- [ ] **No security vulnerabilities introduced** - Run security audit
- [ ] **No technical debt added** - Check debt audit checklist
- [ ] **Documentation updated** - SYSTEM_LOG.md, README, comments
- [ ] **Proper error handling added** - All failure paths explicitly handled
- [ ] **No hardcoded values** - All config in environment variables or config files

---

## When Regressions Occur

**If a regression is discovered after deployment:**

1. **Immediately document**:
   - What broke
   - When it was introduced
   - What change caused it
   - Why the regression wasn't caught

2. **Fix properly**:
   - Revert the breaking change if critical
   - Implement proper fix
   - Add regression test to prevent recurrence

3. **Update SYSTEM_LOG.md**:
   - Log the regression incident
   - Document root cause
   - Document prevention measures added

4. **Learn and improve**:
   - Update testing procedures
   - Add to anti-regression checklist
   - Share lessons learned

---

## Enforcement

Violations of anti-regression rules result in:
- Task marked as incomplete
- Mandatory rework to eliminate regression
- Documentation of the incident in `SYSTEM_LOG.md`
- Addition of regression test to prevent recurrence

**Remember:** Fixing a regression properly takes more time than preventing it in the first place.
