# Module 11: Entra ID Integration
**Intent & Learning Objectives:** Replace account keys with tokens via managed identities.

**Top 2 problems this solves / features provided:**
- Eliminate key distribution
- Centralize authz via RBAC

**Key Features Demonstrated:**
- Create UAMI; assign Blob Data Contributor; token via IMDS

**Architecture Diagram (module-specific)**
```mermaid
flowchart TB
  VM["Linux VM with UAMI"] -->|IMDS Token| Entra["Entra ID"]
  Entra -->|Access Token| VM -->|Blob REST| SA["Storage Account"]

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant VM as VM (UAMI)
  participant Entra as Entra ID
  participant SA as Storage
  VM->>Entra: Get token (IMDS)
  Entra-->>VM: Access token
  VM->>SA: REST with token
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
   bash infra/m11_entra.sh
   ```
   - From a VM with UAMI, call IMDS then Storage REST with token.

## Compliance Notes
- **Least privilege:** Prefer Reader/Contributor per app needs.
- **Rotation:** No static secrets.

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
- Script: `infra/m11_entra.sh`
