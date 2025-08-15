# Module 08: Azure Storage Encryption (CMK)
**Intent & Learning Objectives:** Bring your own keys for stronger control and rotation governance.

**Top 2 problems this solves / features provided:**
- Meet strict key control requirements
- Enable key rotation processes

**Key Features Demonstrated:**
- Create CMK in Key Vault; grant wrap/unwrap; set CMK on SA

**Architecture Diagram (module-specific)**
```mermaid
flowchart TB
  subgraph KeyVault["Azure Key Vault"]
    CMK["Key: cmk-storage"]
  end
  SA["Storage Account"] -->|wrap/unwrap| CMK
  App["App Access"] --> SA

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant SA as Storage
  participant KV as Key Vault
  SA->>KV: wrap/unwrap data keys
  KV-->>SA: Success
  App->>SA: Read/Write (SSE with CMK)
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
   bash infra/m08_encryption_cmk.sh
   ```
   - Rotate CMK version and observe effect; remove MMK fallback.

## Compliance Notes
- **Separation of duties:** KV admins distinct from storage admins.
- **Monitoring:** Alert on key expiration.

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
- Script: `infra/m08_encryption_cmk.sh`
