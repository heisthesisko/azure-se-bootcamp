# Module 17: Azure Storage Sync (Linux-friendly Lab)
**Intent & Learning Objectives:** Show hybrid sync patterns while noting Windows requirement for File Sync.

**Top 2 problems this solves / features provided:**
- Bridge on-prem files to Azure
- Nearline cloud tiering pattern

**Key Features Demonstrated:**
- Azure Files cloud endpoint; rsync/AzCopy job; versioning via snapshots

**Architecture Diagram (module-specific)**
```mermaid
flowchart TB
  subgraph OnPremLinux["On-Prem Linux"]
    NFS["NFS Share /data"]
  end
  AzCopy["AzCopy/Rsync Job"] --> Files["Azure Files: ehr-sync"]
  NFS --> AzCopy
  Note["Azure File Sync requires Windows Server agent – using Linux-friendly alternative for lab"]

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant NFS as On-Prem NFS
  participant Job as AzCopy/Rsync
  participant Files as Azure Files
  NFS->>Job: Read changes
  Job->>Files: Sync to cloud share
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
   bash infra/m17_sync_linux_alt.sh
   ```
   - Run `azcopy sync` from NFS dir to Azure Files; restore via snapshot.

## Compliance Notes
- **Note:** True Azure File Sync requires Windows Server agent.
- **Network:** Consider Private Endpoints for Files.

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
- Script: `infra/m17_sync_linux_alt.sh`
