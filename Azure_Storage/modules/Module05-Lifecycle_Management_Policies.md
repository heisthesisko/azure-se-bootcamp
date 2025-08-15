# Module 05: Lifecycle Management Policies
**Intent & Learning Objectives:** Automate tiering and deletion to meet retention policies.

**Top 2 problems this solves / features provided:**
- Reduce hot storage spend
- Automate defensible deletion

**Key Features Demonstrated:**
- Policy JSON; per-prefix rules; hot→cool→archive→delete

**Architecture Diagram (module-specific)**
```mermaid
flowchart TB
  Hot["Hot Tier"] -->|30d| Cool["Cool Tier"] -->|180d| Archive["Archive Tier"] -->|365d| Delete["Delete"]
  Policy["Management Policy (prefix: phi/)"] --> Hot
  Policy --> Cool
  Policy --> Archive

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant Policy as Lifecycle Policy
  participant Blob as Blobs
  Policy->>Blob: Evaluate lastModified
  Policy->>Blob: Tier to Cool/Archive
  Policy->>Blob: Delete after 365d
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
   bash infra/m05_lifecycle.sh
   ```
   - Review policy with `az storage account management-policy show`.
   - Label datasets by prefix (e.g., `phi/claims/`).

## Compliance Notes
- **Retention:** Map enterprise records schedule to policy.
- **Audit:** Export policy JSON to evidence repo.

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
- Script: `infra/m05_lifecycle.sh`
