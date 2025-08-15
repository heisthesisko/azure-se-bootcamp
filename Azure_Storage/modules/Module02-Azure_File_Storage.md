# Module 02: Azure File Storage
**Intent & Learning Objectives:** Provide SMB shares for clinical and payor operations (reports, batch ETL staging).

**Top 2 problems this solves / features provided:**
- SMB shares without managing file servers
- Snapshots for user recovery

**Key Features Demonstrated:**
- Azure Files SMB 3.0; snapshots; POSIX perms (via NFS if used)

**Architecture Diagram (module-specific)**
```mermaid
flowchart TB
  Linux1["Linux Client
(EHR app)"] -->|SMB 3.0| Share["Azure Files: ehr-files"]
  AVD["Azure VM / AVD Session"] -->|SMB 3.0| Share
  subgraph SA["Storage Account (Files)"]
    Share
  end
  Snap["Share Snapshots"] -.-> Share

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant Client as Linux Client
  participant Files as Azure Files
  Client->>Files: SMB Negotiate (TLS)
  Client->>Files: Create/open file
  Files-->>Client: 200 OK
  Client->>Files: Snapshot request
  Files-->>Client: Snapshot created
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
   bash infra/m02_files.sh
   ```
   - Mount from Linux using CIFS; store mock batch reports.
   - Create a snapshot and restore a file version.

## Compliance Notes
- **Minimum necessary:** Separate PHI vs non-PHI shares.
- **Encryption:** SMB over TLS; disable SMB1.

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
- Script: `infra/m02_files.sh`
