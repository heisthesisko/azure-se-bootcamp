# Module 7: Role-Based Access Control (RBAC)

> [!IMPORTANT]
> Use synthetic ePHI; follow least privilege RBAC; record evidence for audits.

## Intent & Learning Objectives
See README table for full objectives; this scaffold links to scripts and checklists.

## Top Problems Solved
1. Lack of standardized governance across hybrid estates.
2. Limited auditability for healthcare controls (HIPAA/HITRUST).

## Key Features Demonstrated
- Apply/tag resources consistently.
- Execute provided infra scripts (`infra/*.sh`).
- Capture evidence (screenshots/queries) for auditors.

## Architecture Diagram
See `assets/diagrams/module07_flow.mmd`.

## Step-by-Step
Follow the README Quick Start, then run this module’s script(s) and review the comments inline in `infra/` and `scripts/`. Each script is idempotent and safe to re-run.

## Pros, Cons & Warnings
- **Pros:** Repeatable, automatable steps; foundations for later modules.
- **Cons:** Environment-specific values required in `config/.env`.
> [!CAUTION]
> Never run against production subscriptions without change control and approvals.

> [!TIP]
> Commit your filled `config/.env` to a secure secrets store, not to Git.
