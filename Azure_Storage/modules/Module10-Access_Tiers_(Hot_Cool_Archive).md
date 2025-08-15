# Module 10: Access Tiers (Hot/Cool/Archive)
**Intent & Learning Objectives:** Optimize cost via per-blob tiering.

**Top 2 problems this solves / features provided:**
- Reduce cost for cold datasets
- Control rehydration priority

**Key Features Demonstrated:**
- Set-tier operations; Archive & rehydrate

**Architecture Diagram (module-specific)**
```mermaid
flowchart TB
  Blob["cold.bin (Hot)"] -->|Set Tier| Cool["Cool"]
  Cool -->|Archive| Archive["Archive"]
  Archive -->|Rehydrate (High/Std)| Rehyd["Cool/Hot"]

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant Admin
  participant SA as Storage
  Admin->>SA: Set blob tier Cool
  Admin->>SA: Set tier Archive
  Admin->>SA: Rehydrate High priority
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
   bash infra/m10_tiers.sh
   ```
   - Archive `cold.bin`; request rehydrate; monitor status with `az storage blob show`.

## Compliance Notes
- **SLA:** Archive access delays hours.
- **Metadata:** Consider content indexing before archive.

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
- Script: `infra/m10_tiers.sh`
