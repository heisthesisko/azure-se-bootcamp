# Module 13: Immutable Blob Storage (WORM)
**Intent & Learning Objectives:** Demonstrate write-once retention for audit evidence.

**Top 2 problems this solves / features provided:**
- Prevent tampering/deletion
- Support legal hold scenarios

**Key Features Demonstrated:**
- Create container; set time-based policy; protected append

**Architecture Diagram (module-specific)**
```mermaid
flowchart TB
  Ingest["Ingestion Job"] -->|Append/Block Put| Container["Container: compliance (WORM)"]
  Policy["Immutability Policy (30d)"] --> Container
  User -. blocked delete .-x Container

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant Admin
  participant SA as Storage
  Admin->>SA: Create container + WORM policy
  Ingest->>SA: Append blobs
  Admin->>SA: Attempt delete (fails)
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
   bash infra/m13_worm.sh
   ```
   - Attempt delete/overwrite—expect failure until retention expires.

## Compliance Notes
- **Governance:** Carefully review retention periods.
- **Break-glass:** Define emergency procedures.

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
- Script: `infra/m13_worm.sh`
