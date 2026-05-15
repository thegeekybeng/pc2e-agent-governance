---
trigger: always_on
last_updated: 2026-05-15
pc2e_version: 1.0
---

# Privacy and PDPA Controls

> Singapore's Personal Data Protection Act (PDPA) is a legal requirement for all
> platforms operating in Singapore or processing data of Singapore residents.
> This document defines the mandatory privacy controls for all projects governed
> by the PC2E framework.

---

## Legal Basis

The PDPA (Cap. 26 of 2012, as amended by the PDPA Amendment Act 2020) governs the
collection, use, disclosure, and care of personal data in Singapore.

Penalties for non-compliance: Up to SGD 1 million per breach (pre-2021 cap),
now elevated to 10% of annual Singapore turnover for large organisations.

PDPC enforcement actions are public record. Non-compliance is a reputational risk
in addition to a legal one.

---

## Data Classification

All data handled by projects governed by this framework MUST be classified before
processing:

| Class | Definition | Handling Requirement |
| --- | --- | --- |
| **Public** | No impact if disclosed | Standard handling |
| **Confidential** | Business impact if disclosed | Access controls required |
| **Restricted** | Legal or regulatory impact if disclosed | Encryption + audit log required |
| **PII** | Identifies a specific individual | PDPA controls mandatory |

Personal data (PII) is automatically Restricted class.

---

## Singapore PII Patterns — Detection and Masking

The following patterns MUST be detected and masked in all logs, outputs, and stored data.
Never log, display, or persist raw PII.

### NRIC / FIN

Format: `[STFG]XXXXXXX[A-Z]` — letter prefix + 7 digits + checksum letter

```regex
\b[STFG]\d{7}[A-Z]\b
```

Mask as: `[NRIC REDACTED]`

### Passport Number (Singapore)

Format: `E\d{7}[A-Z]`

```regex
\bE\d{7}[A-Z]\b
```

Mask as: `[PASSPORT REDACTED]`

### Singapore Phone Number

Format: `+65 XXXX XXXX` or `XXXXXXXX` (8 digits starting with 6, 8, or 9)

```regex
(\+65[\s-]?)?[689]\d{7}\b
```

Mask as: `[PHONE REDACTED]`

### Singapore Postal Code

Format: 6-digit code `XXXXXX`

```regex
\bS\(?\d{6}\)?\b|\b\d{6}\b(?=.*Singapore)
```

Mask as: `[POSTAL REDACTED]` (only when accompanied by other PII in context)

### CPF Account Number

Format: Same as NRIC — NRIC is the CPF account number

Apply NRIC regex. No separate pattern required.

### SingPass / CorpPass Username

Typically the NRIC. Apply NRIC regex.

### Email Address (general PII)

```regex
\b[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}\b
```

Mask as: `[EMAIL REDACTED]`

---

## The Blind Execution Standard (Core Imperative 4)

The Blind Execution Standard requires that AI agents treat all user-provided data as
ephemeral — processing it to complete the task without retaining, logging, or
referencing it beyond the immediate operation.

**Mandatory behaviours:**

- Do NOT log personal data to SYSTEM_LOG.md
- Do NOT include personal data in Chain of Reasoning documentation
- Do NOT reference personal data in error messages or debug output
- Do NOT retain personal data between sessions
- Do NOT use personal data as examples in documentation

**When PII is encountered in input:**

1. Detect using the regex patterns above
2. Mask immediately before any processing or logging
3. Complete the task using the masked representation
4. Log the event (not the data): "PII detected and masked — [data class] — [timestamp]"

---

## PDPA Mandatory Obligations

### 1. Purpose Limitation

Personal data collected or processed MUST be used only for the purpose for which it
was collected. An agent that receives an NRIC to verify identity MUST NOT use that
NRIC for any other purpose within the same or subsequent sessions.

### 2. Data Minimisation

Request and process only the minimum personal data necessary for the task. If the
task can be completed without personal data, do not request it.

### 3. Consent Gate

Before an AI agent collects or processes personal data from an end user, a consent
gate MUST be presented. The consent gate MUST:

- Identify what data is being collected
- State the purpose of collection
- Identify who will have access to the data
- Provide an option to decline

**Template consent statement:**

```text
This service uses AI assistance to process your request. To provide this service,
we may process the information you share in this conversation. Your data is processed
locally and is not retained after your session ends. Do you consent to proceed?
[YES / NO]
```

### 4. Data Retention

SYSTEM_LOG.md entries MUST NOT contain personal data. If a log entry is found to
contain personal data:

1. Redact immediately
2. Log the redaction event
3. Review the process that allowed PII to reach the log

Log entries are retained for 90 days in SYSTEM_LOG.md, then archived to
SYSTEM_LOG_ARCHIVE.md. Archived logs are retained for 1 year, then deleted.

### 5. Data Subject Rights

Under PDPA, individuals have the right to:

- Access their personal data (respond within 30 days)
- Correct inaccurate personal data (respond within 30 days)
- Withdraw consent (effective immediately)
- Data portability (for data provided under consent)

Projects must document how these rights are exercised via their platform's user
support process.

### 6. Breach Notification

If personal data is involved in a security breach:

- Assess whether the breach is notifiable (likely harm to affected individuals)
- If notifiable: Report to PDPC within 3 days of determination
- Notify affected individuals without undue delay
- Log all breach-related decisions and actions

---

## Local Inference Requirement

Where AI inference processes personal data, the inference MUST run locally (on-device
or on-premises) wherever technically feasible. Cloud inference that transmits personal
data to third-party API providers creates PDPA data-sharing obligations that require
explicit data processing agreements.

**Current framework deployment:** All AI inference runs on local Ollama instances
(Mac Mini M4 Pro via Tailscale, or NAS-hosted models). This satisfies the local
inference requirement.

If migrating to cloud inference (OpenAI, Anthropic, Google APIs), a Data Processing
Agreement (DPA) must be executed with the provider before any personal data is
transmitted.

---

## IP Anonymisation

All web-facing services that log client IP addresses MUST anonymise IPs before storage:

- IPv4: Zero the last octet (`192.168.1.100` → `192.168.1.0`)
- IPv6: Zero the last 80 bits

IP addresses are personal data under PDPA when they can be linked to an individual.

---

## Enforcement

PDPA non-compliance is not a governance finding — it is a legal liability.

**Any feature, log format, or data flow that would cause unmasked personal data to
be retained, logged, or transmitted to an external system is a blocking issue.**

It must be resolved before the feature ships, not after.

---

## Related Documents

- [Governance Framework](governance-framework.md) — Core Imperative 4: Privacy
- [Prompt Injection Defence](prompt-injection-defence.md) — Layer 4: Output schema
- [Mandatory Documentation](mandatory-documentation.md) — SYSTEM_LOG.md standards
- [SECURITY_AUDIT.md](../SECURITY_AUDIT.md) — Requirement 13: PDPA audit findings
