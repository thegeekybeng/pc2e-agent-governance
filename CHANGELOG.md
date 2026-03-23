# Changelog

All notable changes to the **PC2E Agent Governance Framework** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-03-23

### Added

- **`mac-global-workflows/` NAS execution divergence**: Updated `00_pc2e_governance_bootstrap.md` for MacBook Air to explicitly permit native npm/npx/node execution and clarify NAS rules do not apply there.

### Fixed

- **NAS npm/npx enforcement**: Added `nas-execution-rules.md` (NAS-only, not synced to Mac) with a hard rule that ALL Node.js commands on the NAS must run via `docker run`. Rule applies across all operational modes. Updated NAS bootstrap to surface this rule prominently with inline examples.

---

## [1.1.0] - 2026-03-23

### Added

- **`mac-global-workflows/`**: Bundled global_workflows files into the repo for cross-device sync. Run `sync-to-mac.sh` on MacBook Air to deploy.
- **`sync-to-mac.sh`**: Deployment script to sync global_workflows to `~/.gemini/antigravity/global_workflows/` on MacBook Air.
- **`00_pc2e_governance_bootstrap.md`**: Session-zero bootstrap file. Tells the Antigravity agent where the governance framework lives (`pc2e-agent-governance/`), declares the precedence hierarchy, mandates the session startup intake protocol, and documents both device paths.

### Changed

- **`global_workflows/resolving-errors.md`**: Stripped duplicate Debug Mode content. Now defers to `pc2e-agent-governance/modes/debug.md` as authority; retains NAS/Docker-specific additions only.
- **`global_workflows/workflow-docker.md`**: Stripped duplicate Code Mode content. Now defers to `pc2e-agent-governance/modes/code.md` and `global/governance-framework.md`; retains NAS/Docker environment-specific extensions only.
- **`global_workflows/globaldockerworkflow.md`**: Added governance preamble linking to `pc2e-agent-governance/workflows/docker-compose-workflow.md`.

### Fixed

- **Agent folder rename**: Governance bootstrap now explicitly declares that `.agent` has been permanently renamed to `pc2e-agent-governance`. Agents will no longer look for or reference the old `.agent` path.

---

## [1.0.0] - 2026-03-19

### Highlights

Initial production release of the PC2E Agent Governance Framework. This release establishes the core architectural standards for deterministic AI agent operations.

### Added

- **PC2E Protocol Integration**: Formalized Predict, Communicate, and Explain (PC2E) requirements for all agent actions.
- **4-Tier Governance Hierarchy**: Established clear separation between Global, Mode, Workflow, and Template layers.
- **Operational Modes**: Introduced standardized Entry/Exit gates for Orchestrator, Architect, Code, Debug, and Ask modes.
- **Support for Multi-Agent Workflows**: Designed specialized procedures for complex task decomposition and escalation.
- **Branded Documentation**: High-fidelity README with Quick Start, Examples, and Performance Metrics.

### Changed

- **Directory Restructure**: Consolidated legacy rule folders into a unified, kebab-case kebab-case directory structure.
- **Precedence Logic**: Implemented absolute precedence for Global rules over Mode and Workflow specific standards.

### Security

- Zero-vulnerability mandate enforced across all framework layers.
- Strict path isolation and data minimization protocols established.
