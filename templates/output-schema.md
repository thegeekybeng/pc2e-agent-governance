---
trigger: reference
last_updated: 2026-05-15
pc2e_version: 1.0
---

# Output Schema — PC2E Agent Responses

> Every agent response that makes a technical claim, proposes a code change, or
> escalates MUST conform to the schema for its active mode. Deviations from schema
> are injection indicators (see `global/prompt-injection-defence.md` Layer 4).

---

## Universal Fields (All Modes)

Every substantive response MUST include:

| Field | Required | Format | Example |
| --- | --- | --- | --- |
| `confidence` | Yes — for any technical claim | Float 0.0–1.0 + tier + source + caveat | `[0.92 T1 — verified in code.md:L95, assumption: nginx version unchanged]` |
| `assumptions` | Yes — if any assumption was made | Bulleted list | `- Assuming Docker daemon is running` |
| `impact_zone` | Yes — for any file or system change | List of affected files/services | `Affects: global/governance-framework.md, README.md` |

Responses that omit these fields when making technical claims are non-compliant.

---

## Mode-Specific Schemas

### Orchestrator Mode

```text
Response structure:
1. Task decomposition — numbered sub-tasks with assigned agents
2. Dependency map — which sub-tasks must complete before others
3. Confidence: [score] — confidence in the decomposition approach
4. Assumptions: [list]
5. Escalation condition: [state when the orchestrator will pause and ask the user]
```text

### Architect Mode

```text
Response structure:
1. Technology recommendation — name + version + rationale
2. Scoring: [score]/10 using templates/scoring-rubric.md criteria
3. Alternatives considered — at least 2, with scores and rejection reasons
4. Constraints — what this choice forecloses
5. Confidence: [score] — confidence in the recommendation
6. TDR required: [YES/NO] — if YES, create before implementation proceeds
```text

### Code Mode

```text
Response structure:
1. Impact zone — files to be created/modified/deleted
2. Implementation plan — numbered steps
3. Confidence: [score] — confidence in correctness of the implementation
4. Chain of Reasoning — why this approach was chosen over alternatives
5. Verification steps — commands to confirm the change works
6. HITL required: [YES/NO] — if YES, do not proceed until user confirms
```text

### Debug Mode

```text
Response structure:
1. Root cause hypothesis — single most likely cause with evidence
2. Evidence — specific log lines, error messages, or observations supporting the hypothesis
3. Confidence: [score] — confidence in the root cause identification
4. Ruling out — what was considered and eliminated
5. Fix plan — numbered steps
6. Regression risk — what existing functionality might be affected
```text

### Ask Mode

```text
Response structure:
1. Answer — direct response to the question
2. Source — specific file:line or URL where the answer was verified
3. Confidence: [score] — confidence in the answer's accuracy
4. Caveats — what the answer does NOT cover or where it might be wrong
5. Related — links to related framework sections if relevant
```text

---

## Escalation Format

When an agent escalates (confidence below 80%, HITL trigger, or conflict detected):

```text
ESCALATION REQUIRED

Reason: [one of: LOW_CONFIDENCE / HITL_TRIGGER / RULE_CONFLICT / LOOP_DETECTED]

Context:
- Current task: [describe what was being attempted]
- Blocking condition: [why escalation is required]
- Confidence: [score if LOW_CONFIDENCE]
- Attempts: [count if LOOP_DETECTED]

Options for user:
(A) [option A with trade-off]
(B) [option B with trade-off]
(C) Provide additional context so I can retry

Awaiting your direction. I will not proceed until you respond.
```text

---

## Non-Compliant Response Examples

The following patterns indicate the agent is operating outside governance constraints:

```text
❌ "I'll just try restarting the service and see what happens."
   Missing: confidence, impact zone, assumptions

❌ "Here's the code." [code block with no context]
   Missing: impact zone, chain of reasoning, verification steps

❌ "This should work." [no confidence score]
   Missing: confidence score, source

❌ Proceeding with a destructive operation without stating it's HITL-required
   Missing: HITL gate declaration
```text

---

## Enforcement

Non-compliant outputs MUST be rejected by the human reviewer. If an agent repeatedly
produces non-compliant outputs, this is an injection indicator (Layer 4) or a
governance context loading failure. Reload governance context and retry.

---

## Related Documents

- `global/pc2e-framework.md` — Confidence scoring tiers and escalation thresholds
- `global/prompt-injection-defence.md` — Layer 4: Output schema as injection defence
- `global/loop-breaking-protocol.md` — Escalation format for loop conditions
- `templates/merge-checklist.md` — Output schema verification as a merge gate
