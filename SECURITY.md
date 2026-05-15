# Security Policy

## Supported Versions

| Version | Supported |
| --- | --- |
| v1.x (current) | ✅ Yes |
| < v1.0 | ❌ No |

## Reporting a Vulnerability

The PC2E Agent Governance Framework is a governance documentation layer. Security
vulnerabilities in this context include:

- A rule in `global/` that, when followed, causes a consuming project to implement
  an insecure pattern (e.g., inadvertently permitting hardcoded secrets)
- A gap in the framework that leaves a known attack vector (e.g., prompt injection)
  unaddressed across all consuming projects
- A supply chain issue (e.g., a compromised commit that weakens a security mandate)
- A canary token detection event (see Canary Token Policy in `global/governance-framework.md`)

### How to Report

**Do not open a public GitHub issue for security vulnerabilities.**

Report vulnerabilities via:

1. **GitHub Security Advisories** (preferred): Use the "Report a vulnerability" button
   on the Security tab of this repository
2. **Direct contact**: <andrew@thegeekybeng.com>

### What to Include

- Description of the vulnerability and which files are affected
- The specific rule or gap that creates the security risk
- An example of how a consuming project would be harmed if following the vulnerable rule
- Suggested remediation (if known)

### Response SLA

| Step | Target |
| --- | --- |
| Acknowledgement | Within 48 hours |
| Initial assessment | Within 5 business days |
| Remediation (critical) | Within 14 days |
| Remediation (moderate) | Within 30 days |
| Public disclosure | After remediation is deployed and consuming projects notified |

### Canary Token Detections

If you detect the framework canary token (`PCE2-CANARY-2026-7f3a9b2c-DO-NOT-USE-IN-REQUESTS`)
appearing in an external request log or API call, this indicates system prompt exfiltration.

Report immediately via the channels above. Include:

- The log or request where the token appeared
- The service/platform where it was detected
- Timestamp of detection

This is treated as a P0 incident with 24-hour response SLA.

## Security Controls

See [SECURITY_AUDIT.md](SECURITY_AUDIT.md) for the full 15-requirement security audit
and [README.md](README.md#owasp-llm-top-10--framework-compliance) for the OWASP LLM
Top 10 compliance table.

## Disclosure Policy

Security issues in this framework are disclosed publicly after:

1. The vulnerability is confirmed
2. A patch is deployed to the repository
3. A minimum 7-day waiting period for consuming projects to update

We follow responsible disclosure. We will credit reporters in the security advisory
unless they prefer to remain anonymous.
