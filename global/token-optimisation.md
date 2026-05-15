---
trigger: always_on
last_updated: 2026-05-15
pc2e_version: 1.0
---

# Token Optimisation

> Efficient token usage is a resource governance imperative. Wasted tokens are wasted cost,
> latency, and context capacity — all of which degrade agent performance at scale.

---

## Core Principle

**Token consumption must be treated as a finite resource, not a free variable.**

Every token loaded into context has a cost: monetary (API pricing), temporal (inference
latency), and functional (context window capacity consumed). The agent and the systems
deploying it MUST apply the four methods below in priority order.

---

## Method 1 — Prefix Caching (Highest Priority)

**What it is:** Structuring prompts so that static governance content appears first in the
context window, enabling provider-level prompt caching to eliminate repeated payment for
identical content.

**Why it is the highest priority:** It delivers 90% cost reduction on cached tokens with
zero behaviour trade-off. The agent sees identical content — it simply stops being billed
for it on every call after the first.

**Implementation requirements:**

1. **Static content first.** Global governance files MUST appear at the top of the prompt,
   before any dynamic content (user messages, project context, session history).

2. **Set a cache breakpoint** after the static governance block. The exact mechanism
   depends on the provider:

   | Provider | Mechanism | Cache Duration |
   | --- | --- | --- |
   | Anthropic (Claude) | `cache_control: {"type": "ephemeral"}` in API | 5 min; extendable with explicit TTL |
   | OpenAI (GPT-4o) | Implicit — automatic on prefixes > 1,024 tokens | 5–10 min |
   | Google (Gemini) | Context Caching API — explicit cache creation | Minimum 1 hour |

3. **Keep the cached block identical across calls.** Any modification to the cached prefix
   invalidates the cache and triggers a full re-computation. Do not inject dynamic values
   (timestamps, session IDs) into the governance block.

4. **Load order for this framework:**

   ```text
   [CACHE BOUNDARY START]
   global/governance-framework.md
   global/pc2e-framework.md
   global/loop-breaking-protocol.md
   global/anti-regression-rules.md
   global/mandatory-documentation.md
   global/token-optimisation.md
   [CACHE BOUNDARY END — set cache_control breakpoint here]
   --- dynamic content below this line ---
   modes/<active-mode>.md
   PORTS.md
   Project_Context.md
   SYSTEM_LOG.md
   <user message>
   ```

**Expected outcome:** On a typical session with 12,750 cached tokens, the cost after the
first call drops to ~1,275 tokens equivalent. At scale across dozens of daily sessions,
this is the single highest-ROI optimisation available.

---

## Method 2 — Lazy Loading (Selective Context Injection)

**What it is:** Loading only the rule files required for the current task type, rather than
injecting the entire framework on every session start.

**When to apply:** When context window capacity is constrained (< 32K tokens) or when the
active task is narrowly scoped.

**Loading strategy by context budget:**

| Context Budget | Load |
| --- | --- |
| 128K+ tokens | Full framework — all global files + active mode + project context |
| 32K–128K tokens | `governance-framework.md` + `pc2e-framework.md` + `loop-breaking-protocol.md` + active mode only |
| < 32K tokens | `governance-framework.md` only; reference other files by name and load on demand |

**Rules:**

- The active mode file MUST always be loaded — it is not optional regardless of budget.
- `loop-breaking-protocol.md` is the highest-priority optional file. Drop others before
  dropping this one.
- Never drop `governance-framework.md`. It contains the four core imperatives and is the
  minimum viable governance layer.
- Project context files (`PORTS.md`, `Project_Context.md`, `SYSTEM_LOG.md`) are dynamic
  and must always sit outside the cached prefix regardless of budget.

---

## Method 3 — Hierarchical References Over Full Inclusion

**What it is:** Using pointer-style references to documents rather than embedding their
full text, allowing the agent to fetch content on demand rather than loading everything
upfront.

**When to apply:** For mode files, workflow files, and template files that are only
relevant to specific task phases — not for global rules (which should always be cached
per Method 1).

**Pattern:**

```markdown
<!-- Instead of embedding the full TDR template inline -->
When a new technology is introduced, create a TDR using the format in:
templates/tdr-template.md

<!-- The agent reads the template only when it needs to create a TDR -->
```

**What NOT to use this method for:**

- Global governance files (must be fully loaded and cached — Method 1)
- The active mode file (must be fully loaded)
- `loop-breaking-protocol.md` (partial loading creates gaps in loop detection)

---

## Method 4 — Prompt Compression (Last Resort)

**What it is:** Distilling verbose rule content into semantically equivalent but shorter
representations. Reduces token count at the cost of nuance and specificity.

**Priority:** Apply only after Methods 1–3 are fully implemented. Compression introduces
the risk of semantic loss — a compressed rule that drops a critical qualifier can cause
the agent to apply it incorrectly.

**Safe compression patterns:**

- Replace multi-paragraph explanations with a numbered checklist where each item maps
  1:1 to an original requirement.
- Use quick-reference cards (as in `loop-breaking-protocol.md`) to distil lengthy
  protocols to their essential decision logic.
- Remove worked examples from loaded context; retain them in the source file for
  reference only.

**Prohibited compression patterns:**

- Merging rules from different imperatives into a single statement (creates ambiguity
  about which imperative governs which scenario).
- Removing the confidence threshold (80%) or loop limit (2 attempts) — these are
  quantitative gates that must remain explicit.
- Compressing enforcement sections — consequences for violations must remain specific.

---

## Anti-Patterns

- ❌ **Loading all framework files on every call without caching.** Full-cost token billing
  on static content that never changes is waste, not governance.
- ❌ **Injecting timestamps or session IDs into the governance block.** This invalidates
  the cache prefix on every call and negates Method 1 entirely.
- ❌ **Compressing global rules before implementing caching.** Compression introduces risk.
  Caching eliminates cost with zero risk. Always exhaust the zero-risk option first.
- ❌ **Dropping `loop-breaking-protocol.md` to save tokens.** The performance cost of a
  single undetected loop vastly exceeds the token cost of loading the file.

---

## Token Budget Decision Tree

```text
START: New session initialising
│
├── Is prompt caching available from the provider?
│   ├── YES → Apply Method 1 (prefix caching). Set cache boundary after global files.
│   └── NO  → Skip to Method 2.
│
├── What is the available context budget?
│   ├── 128K+ → Load full framework (all global + active mode + project context)
│   ├── 32K–128K → Load core global files + active mode only (Method 2)
│   └── < 32K  → Load governance-framework.md only; use hierarchical refs (Methods 2+3)
│
├── Are workflow or template files needed?
│   ├── YES → Load via hierarchical reference on demand (Method 3)
│   └── NO  → Skip
│
└── Is context still over budget after Methods 1–3?
    ├── YES → Apply targeted compression to non-critical sections (Method 4)
    └── NO  → Proceed
```

---

## Enforcement

Token optimisation is a **resource governance requirement**, not a performance suggestion.

Deploying this framework without applying Method 1 (prefix caching) where the provider
supports it is a violation of Core Imperative 1 (Scalability) — it introduces unnecessary
cost that compounds with usage volume and degrades the system's ability to scale.

**Verify caching is active** by checking provider-side token usage metrics. A cache hit
should show significantly reduced input token counts on calls after the first in a session.
