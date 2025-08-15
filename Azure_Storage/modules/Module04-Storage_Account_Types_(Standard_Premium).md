# Module 04: Storage Account Types (Standard/Premium)
**Intent & Learning Objectives:** Select the right account for workload SLAs and budget.

**Top 2 problems this solves / features provided:**
- Right-size latency/throughput
- Match feature sets to needs

**Key Features Demonstrated:**
- GPv2 vs Premium BlockBlobStorage vs FileStorage

**Architecture Diagram (module-specific)**
```mermaid
flowchart TB
  subgraph Accounts
    GPv2["GPv2 (Standard_LRS)"]
    BBS["Premium BlockBlobStorage"]
    FS["Premium FileStorage"]
  end
  WorkloadA["Clinical Docs"] --> GPv2
  WorkloadB["Imaging Objects"] --> BBS
  WorkloadC["SMB Dept Shares"] --> FS

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant Admin
  Admin->>Azure: Create GPv2 + Premium accounts
  Admin->>Azure: Run throughput tests (AzCopy)
  Azure-->>Admin: Metrics for comparison
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
   bash infra/m04_types.sh
   ```
   - Use AzCopy to measure throughput; compare metrics in Portal/CLI.

## Compliance Notes
- **Cost control:** Use Hot/Cool/Archive per dataset.
- **SLA:** Premium accounts for predictable latency.

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
- Script: `infra/m04_types.sh`
