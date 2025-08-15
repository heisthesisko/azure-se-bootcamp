# Module 19: Confidential Storage (Preview)
**Intent & Learning Objectives:** Demonstrate encryption-in-use patterns with Confidential VMs.

**Top 2 problems this solves / features provided:**
- Protect data while processed
- Defense in depth with client-side enc

**Key Features Demonstrated:**
- Confidential VM; client-side AES-GCM; blob versioning

**Architecture Diagram (module-specific)**
```mermaid
flowchart TB
  CVM["Confidential VM"] -->|Client-side enc| Blob["Blob Container"]
  Key["Ephemeral Data Key (AES-GCM)"] --> CVM
  SA["Storage Account (Versioning)"] --- Blob

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant CVM as Confidential VM
  participant SA as Storage
  CVM->>CVM: Encrypt data (AES-GCM)
  CVM->>SA: Upload ciphertext
  SA-->>CVM: 201 Created
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
   bash infra/m19_confidential.sh
   ```
   - Run `app/ai/cse_upload.py` from CVM; verify ciphertext.

## Compliance Notes
- **Attestation:** Validate CVM trust before processing.
- **Key mgmt:** Never store keys with data.

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
- Script: `infra/m19_confidential.sh`
