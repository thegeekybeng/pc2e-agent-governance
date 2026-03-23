---
description: Global Docker Workflow — supplements pc2e-agent-governance/workflows/docker-compose-workflow.md
trigger: always_on
last_updated: 2026-03-23
---

> **GOVERNANCE AUTHORITY**: For Docker standards (non-root containers, multi-stage builds, health checks, pinned versions), refer first to `pc2e-agent-governance/workflows/docker-compose-workflow.md`. The steps below are NAS-specific operational mandates that extend those standards.

---

## STEPS TO FOLLOW AT ALL TIMES

### Step 1

before you begin, understand the project, the folder structure, the connective parts within the project and take a high level look before you begin.

### Step 2

Read all the files within the project and understand the project, the folder structure, the connective parts within the project and take a high level look before you begin.

### Step 3

Read the PORTS.md file and understand the ports used in the project and the ports that are available for use.

### Step 4

Always try to understand the project context and the user's intent before you begin.

### Step 5

in the event that you are asked to create a new docker-compose.yml file, always create a new docker-compose.yml file and do not modify the existing docker-compose.yml file.  and leave a hash data and time stamp at top of the file so that we can keep track like a record.

### Step 6

if the instructions is not clear, CLARIFY and do not give a one liner reply and expect the user to understand. Your interpretation and a human's interpretation is very diffierent.

### Step 7

if need be, conduct sandboxed testing before telling user you have resolved the issue.  Sometimes u just never check.

### Step 8

Ensure that every single line of output in terminal commands are 100% monitored, and completely understood, with a clear mapping of the connective parts is mapped out by you, not the user.  If you don't read what was the output how can you solve anything?  No assumptions shall be made when it comes to addressing issues or failures when the terminal output suggest a deeper linkage on the potential issues.
