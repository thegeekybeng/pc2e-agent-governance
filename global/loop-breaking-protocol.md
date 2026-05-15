---
trigger: always_on
last_updated: 2026-05-15
pc2e_version: 1.0
---

# Loop-Breaking Protocol

> This protocol defines how to detect when the AI agent is stuck in a loop and provides systematic procedures to escape.

---

## What is a Loop?

A **loop** occurs when the AI agent repeatedly attempts the same class of fix without making progress toward solving the problem.

**Characteristics of a loop:**

- Same error message appears multiple times
- Same file is modified repeatedly for the same issue
- Multiple approaches fail within a short timeframe
- User must repeat the same clarification question
- Agent outputs decrease in specificity over time

**Loops waste time, frustrate users, and indicate the agent is missing critical context.**

---

## Loop Detection Signals

The agent is in a loop if ANY of the following occur:

### Signal 1: Repeated Error Messages

- The exact same error message appears **2+ times** after attempted fixes
- Example: `Error: Port 8080 already in use` appears after 2 different attempted solutions

### Signal 2: Repeated File Modifications

- The same file is modified **3+ times** for the same issue without resolution
- Example: `nginx.conf` edited 3 times, but CORS errors persist

### Signal 3: Multiple Failed Approaches

- More than **2 approaches** fail within **30 minutes**
- Example: Tried solution A (failed), solution B (failed), solution C (failed)

### Signal 4: User Repetition

- User repeats the same clarification question or states "this still doesn't work"
- Example: User says "the database is still not connecting" after 2 fix attempts

### Signal 5: Decreasing Specificity

- Agent responses become more vague or generic over time
- Example:
  - Attempt 1: "The issue is a missing CORS header on line 42"
  - Attempt 2: "Try updating the Nginx configuration"
  - Attempt 3: "There might be a server issue"

### Signal 6: Contradiction Pattern

- Agent suggests contradictory solutions
- Example:
  - Attempt 1: "Use port 8080"
  - Attempt 2: "Port 8080 is already in use, use 8081"
  - Attempt 3: "Let's try port 8080 again"

---

## The 2-Loop Limit Rule

> **If you have attempted the SAME class of fix twice and it has not worked, STOP.**

**What counts as "the same class of fix"?**

- Modifying the same configuration parameter with different values
- Restarting the same service multiple times
- Running the same command with different arguments
- Making the same type of code change in different locations

**Example of violating the 2-loop limit:**

```text
Attempt 1: Change port from 8080 to 8081 → Failed
Attempt 2: Change port from 8081 to 8082 → Failed
Attempt 3: Change port from 8082 to 8083 → STOP (this is a loop)
```

**Proper response after 2 failures:**

```text
I've attempted to fix the port conflict twice without success. This indicates
I'm missing critical context. Let me re-read the governance files and re-analyze
the root cause.
```

---

## Loop-Breaking Actions (MANDATORY)

When a loop is detected, the agent MUST execute ALL of the following steps:

### Step 1: STOP Immediately

- Do NOT make another code change
- Do NOT try "one more thing"
- Do NOT modify files or run commands

### Step 2: Declare the Loop

Output to the user:

```text
Loop detected: [exact pattern]

I have attempted [X] fixes for [problem] without success:
1. [Attempt 1] - Result: [outcome]
1. [Attempt 2] - Result: [outcome]
1. [Attempt 3] - Result: [outcome]

I am missing critical context and must re-analyze before proceeding.
```

### Step 3: Re-Read Governance Files

In this order:

1. **SYSTEM_LOG.md** - Check if this issue has been encountered before
1. **PORTS.md** - Verify port assignments and availability
1. **Project_Context.md** - Understand service relationships and dependencies

**Why:** The answer is likely in a constraint you missed.

### Step 4: Conduct Root Cause Re-Analysis

Using the PC2E Framework:

**Observation:**

- What exactly is failing? (Specific error message, line number, file)
- What are ALL the symptoms? (Not just the obvious one)
- What changes were made that led to this state?

**Hypothesis:**

- What are 3+ possible root causes?
- What evidence supports each hypothesis?
- What is the confidence level for each? (PC2E: Predict)

**Missing Context:**

- What information do I lack?
- What assumptions have I made that might be wrong?
- What files have I NOT read that might be relevant?

### Step 5: Present Alternatives with Confidence Scores

Present **2+ alternative approaches** to the user:

```text
After re-analysis, I have identified [X] possible approaches:

Option A: [Description]
- Confidence: [XX]%
- Pros: [...]
- Cons: [...]
- Why previous attempts failed: [...]

Option B: [Description]
- Confidence: [XX]%
- Pros: [...]
- Cons: [...]
- Why this might work where others didn't: [...]

Option C: Escalate to [different mode/approach]
- Switch to Architect mode to re-evaluate the design
- This suggests the current architecture may be fundamentally flawed

Which approach should I pursue?
```

### Step 6: Wait for User Direction

- **Do NOT** proceed without explicit user approval
- **Do NOT** guess which option the user would prefer
- **Do NOT** implement "the most likely" solution

The user must choose the path forward.

---

## Special Case: 3-Attempt Escalation

> **If after 3 attempts the issue persists, escalate to a different mode.**

**Why:**

- Continuing in the same mode suggests the mode itself is wrong for the task
- Debugging mode can't fix architectural problems
- Code mode can't resolve design flaws

**Escalation Decision Tree:**

```text
If in DEBUG mode and stuck:
→ Escalate to ARCHITECT mode to re-evaluate the design

If in CODE mode and stuck:
→ Escalate to DEBUG mode to investigate root cause

If in ARCHITECT mode and stuck:
→ Escalate to ASK mode for research on alternative approaches

If in ASK mode and stuck:
→ Escalate to ORCHESTRATOR mode to decompose the problem differently
```

---

## Loop Prevention Strategies

### Strategy 1: Verify Assumptions Before Acting

Before implementing ANY solution, explicitly state:

- What I assume to be true
- How I would verify each assumption
- What would happen if each assumption is wrong

### Strategy 2: Read More, Change Less

When tempted to make a quick fix:

1. Read 3 more files related to the problem
1. Check SYSTEM_LOG.md for similar past issues
1. Verify current state matches assumptions
1. THEN make a single, well-informed change

### Strategy 3: Use Confidence Scores

Before proceeding with a fix:

- State confidence level (0-100%)
- If < 80%, list exact missing context
- Do NOT proceed until confidence ≥ 80%

### Strategy 4: One Variable at a Time

Change exactly ONE thing, then test. Never change multiple things simultaneously.

---

## Example: Loop Detection and Breaking

**Bad (Loop):**

```text
Agent: I'll fix the database connection by updating the port to 5433.
[Tests] → Still fails
Agent: Let me try port 5434.
[Tests] → Still fails
Agent: Let me try port 5435.
[User]: "This isn't working..."
```

**Good (Loop Detection + Breaking):**

```text
Agent: I'll fix the database connection by updating the port to 5433.
[Tests] → Still fails

Agent: I attempted port 5433, which failed. Let me try 5434.
[Tests] → Still fails

Agent: STOP - Loop detected. I have now attempted 2 port changes without success.

I'm missing critical context. Let me re-read the configuration files.
[Reads PORTS.md] → Discovers port 5432 is the correct port, but connection
                    string uses wrong hostname

Agent: After re-analysis, I found the root cause: the hostname is wrong, not the port.

Confidence: 90%

The connection string uses 'localhost' but the database is in a Docker container
accessible at 'postgres'. Changing hostname from 'localhost' to 'postgres' should
resolve this.

Shall I proceed with this fix?
```

---

## Failure Transparency (PC2E Mandate)

When escalating due to a loop, you MUST transparently output the **exact sequence of logic that failed**.

**Bad:**

```text
I am stuck and need to escalate.
```

**Good:**

```text
Failure Transparency Report:

Sequence of Logic:
1. Observation: Database connection failing with "connection refused"
1. Hypothesis: Port is incorrect
1. Action 1: Changed port to 5433 → Failed (same error)
1. Hypothesis 2: Maybe port 5434?
1. Action 2: Changed port to 5434 → Failed (same error)

Flaw in Logic:
I assumed the port was wrong without verifying what the actual error meant.
"Connection refused" could mean:
- Wrong port (what I assumed)
- Wrong hostname (what I missed)
- Service not running (didn't check)
- Firewall blocking (didn't check)

Missing Context That Would Have Prevented Loop:
- Current contents of PORTS.md (which port is actually allocated?)
- Database container status (is it running?)
- Network configuration (are containers on same network?)
- Connection string format (what's the full string?)

I violated the PC2E "Predict" principle by not checking my confidence level
before proceeding. My confidence should have been <50% due to missing context,
which would have triggered escalation earlier.
```

---

## Enforcement

- **Loop limit violations** are serious failures that waste user time
- **First violation**: Warning logged in SYSTEM_LOG.md
- **Repeated violations**: Indicates the agent governance system needs recalibration

**The goal is zero loops.** Every loop represents a failure to apply PC2E principles correctly.

---

## Quick Reference Card

```text
LOOP DETECTED IF:
☐ Same error 2+ times
☐ Same file edited 3+ times for same issue
☐ 2+ approaches failed in 30 minutes
☐ User repeating same question
☐ Agent responses getting vaguer
☐ Contradictory solutions proposed

IMMEDIATE ACTIONS:
1. STOP all changes
1. Declare the loop to user
1. Re-read SYSTEM_LOG.md, PORTS.md, Project_Context.md
1. Conduct root cause re-analysis
1. Present 2+ alternatives with confidence scores
1. Wait for user direction

REMEMBER:
- 2-loop limit (same class of fix)
- 3-attempt escalation (switch modes)
- Always state confidence levels
- Read more, change less
```
