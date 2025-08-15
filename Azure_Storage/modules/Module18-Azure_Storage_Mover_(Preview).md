# Module 18: Azure Storage Mover (Preview)
**Intent & Learning Objectives:** Orchestrate migrations at scale from NAS to Blob.

**Top 2 problems this solves / features provided:**
- Agent-based scalable migration
- Job scheduling and retries

**Key Features Demonstrated:**
- Storage Mover resource; project; endpoints

**Architecture Diagram (module-specific)**
```mermaid
flowchart TB
  Source["NFS/SMB Source"] --> Agent["Storage Mover Agent"]
  Agent --> Job["Job Definition"]
  Job --> Blob["Blob Container: phi"]

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant Agent
  participant Project
  participant Blob
  Agent->>Project: Register
  Project->>Blob: Write data via job
```

## Step-by-Step Instructions (from zero)
> [!IMPORTANT]
> Use **mock/test data** only. Treat all artifacts as ePHI for discipline.
1. **Environment prep**
   ```bash
   cp config/env.sample config/.env
   code config/.env
   bash infra/00_prereqs.sh
   ```
2. **Deploy & configure**
   ```bash
   bash infra/m18_mover.sh
   ```
   - Register agent and run a test job to `phi` container.

## Compliance Notes
- **Readiness:** Scan for long paths/invalid chars.
- **Cutover:** Plan incremental sync.

## Pros, Cons & Warnings
**Pros**
- Built-in security controls (TLS, SSE, RBAC).
- Azure-native automation and scalability.
- Scriptable with Azure CLI for repeatability/audits.

**Cons**
- Misconfiguration of SAS, public network access, or RBAC can expose data.
- Some features (e.g., RA-GRS, Premium SKUs) have cost trade-offs.
- Lifecycle policy evaluation is periodic, not immediate.

> [!CAUTION]
> Validate access via Entra ID tokens (Modules 11–12) and restrict public access (Module 9).
> [!TIP]
> Tag resources (e.g., `env=training`, `data=ephi`) to drive cost/compliance reports.

## Files & Scripts
- Script: `infra/m18_mover.sh`
