# Module 01: Azure Blob Storage
**Intent & Learning Objectives:** Store and retrieve unstructured ePHI (clinical docs, HL7/FHIR attachments) with secure SAS patterns.

**Top 2 problems this solves / features provided:**
- Elastic ePHI object store
- Controlled client uploads via SAS

**Key Features Demonstrated:**
- Containers, blob types; SAS; SSE/TLS

**Architecture Diagram (module-specific)**
```mermaid
flowchart TB
  UserApp["PHP Web (Uploader)"] -->|SAS PUT| BlobC["Blob Container: phi"]
  subgraph StorageAccount["Storage Account (GPv2)"]
    BlobC
  end
  Note["TLS 1.2+, SSE at rest"]

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant User
  participant PHP as PHP Uploader
  participant SA as Storage (Blob)
  User->>PHP: Select file
  PHP->>SA: PUT blob with SAS
  SA-->>PHP: 201 Created
  PHP-->>User: Upload success URL
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
   bash infra/m01_blob.sh
   ```
   - Export the SAS as env vars and run the PHP uploader in `app/web`.
   - List blobs with `az storage blob list` to verify.

## Compliance Notes
- **HIPAA:** Use short-lived SAS and minimum privileges.
- **HITRUST:** Log reads/writes (Module 14).

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
- Script: `infra/m01_blob.sh`
