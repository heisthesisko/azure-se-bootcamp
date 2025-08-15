# Module 03: Azure Disk Storage
**Intent & Learning Objectives:** Back low-latency databases (PostgreSQL on VM) with durable managed disks.

**Top 2 problems this solves / features provided:**
- Consistent IOPS for DB volumes
- Attach/expand without data loss

**Key Features Demonstrated:**
- Premium disk creation; attach; filesystem mount

**Architecture Diagram (module-specific)**
```mermaid
flowchart TB
  VM["Linux VM (Ubuntu)"] --- DataDisk["Managed Disk (Premium)"]
  DataDisk --> Snap["Snapshots"]
  DataDisk --> Backup["Disk Backup (optional)"]

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant Admin
  participant Azure as Azure Compute
  Admin->>Azure: Create disk + attach to VM
  Azure-->>Admin: Disk attached
  Admin->>VM: mkfs + mount /data
  VM-->>Admin: Ready
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
   bash infra/m03_disks.sh
   ```
   - SSH to VM; format `/dev/sdc`; mount `/data`; validate persistence after reboot.

## Compliance Notes
- **ePHI at rest:** SSE by default; consider ADE for disks.
- **Backups:** Snapshots and Azure Backup.

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
- Script: `infra/m03_disks.sh`
