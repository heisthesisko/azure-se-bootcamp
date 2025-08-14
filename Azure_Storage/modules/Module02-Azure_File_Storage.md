# Module 02: Azure File Storage
**Intent & Learning Objectives:** Managed SMB/NFS file shares for clinical apps and departmental shares.

**Top 2 problems this solves / features provided:**
- Share EHR app files with SMB
- Lift-and-shift file servers to Azure Files

**Key Features Demonstrated:**
- - SMB 3.0 over TLS; Azure Files shares
- - AD DS/AADDS integration options (out of scope to configure fully here)
- - Snapshot and share-level backups

**Architecture Diagram**
```mermaid
flowchart TB
  subgraph Azure ["Azure Subscription"]
    RG["Resource Group"]
    SA["Storage Account"]
  end
  subgraph OnPrem ["On-Prem (Hyper-V)"]
    VyOS["VyOS VPN"]
    Web["Apache/PHP"]
    DB["PostgreSQL"]
    AI["AI Server (Python)"]
  end
  VyOS --- RG
  Web --> SA
  AI --> SA
  DB --> SA
```
*See also:* `assets/diagrams/module02_flow.mmd`

**Sequence Overview**
```mermaid
sequenceDiagram
  participant User
  participant Web as PHP Web
  participant SA as Azure Storage
  User->>Web: Upload file
  Web->>SA: PUT blob via SAS
  SA-->>Web: 201 Created
  Web-->>User: URL + checksum
```
*See also:* `assets/diagrams/module02_sequence.mmd`

## Step-by-Step Instructions
> [!IMPORTANT]
> Use only generated mock data. Treat all artifacts as ePHI for discipline.
> [!TIP]
> Open a VS Code terminal. All scripts are idempotent where possible.

1. **Prepare environment**
   ```bash
   cp config/env.sample config/.env
   code config/.env  # set RG_NAME, LOCATION, etc.
   bash infra/00_prereqs.sh
   ```
2. **Run the module script**
   ```bash
   bash infra/m02_files_basics.sh
   ```
3. **Validate outcome**
   - Mount the Azure File share via SMB on Linux: `sudo mount -t cifs //ACCOUNT.file.core.windows.net/ehr-files /mnt/ehr -o vers=3.0,username=AZURE\\ACCOUNT,password=KEY,dir_mode=0770,file_mode=0770,serverino`

## Compliance Notes
> [!IMPORTANT]
> **HIPAA/HITRUST:** Enforce least-privilege. Log access (Module 14), keep audit trails (Module 15), and restrict network exposure (Module 9).

## Pros, Cons & Warnings
**Pros**
- Elastic scale and durability for clinical content.
- Native encryption at rest and TLS in transit.
- Broad ecosystem integration (SDK/CLI/REST).

**Cons**
- Misconfigured public access can expose data—prefer Private Endpoints.
- SAS mismanagement (over-broad scope/long expiry) increases risk.
- Some enterprise features require additional Azure services (cost).

> [!CAUTION]
> Test in non-production subscriptions. Some modules (GRS, Premium) incur higher costs.
> [!TIP]
> Use tags (e.g., `env=training`, `app=hcws`) for cost reporting and governance.

## Files & Scripts
- Module script: `infra/m02_files_basics.sh`
- Diagrams: `assets/diagrams/module02_flow.mmd`, `assets/diagrams/module02_sequence.mmd`
- App demo: `app/web/index.php` (SAS uploader), `app/ai/cse_upload.py` (client-side encryption demo)
