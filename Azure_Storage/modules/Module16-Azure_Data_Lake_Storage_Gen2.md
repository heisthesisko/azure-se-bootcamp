# Module 16: Azure Data Lake Storage Gen2
**Intent & Learning Objectives:** Analytics lake for research/reporting.

**Top 2 problems this solves / features provided:**
- HNS
- ACLs/posix-style permissions

**Key Features Demonstrated:**
- - Hierarchical namespace (HNS) & DFS endpoint
- - POSIX ACLs for granular access
- - Analytics-friendly layout for research

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
*See also:* `assets/diagrams/module16_flow.mmd`

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
*See also:* `assets/diagrams/module16_sequence.mmd`

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
   bash infra/m16_adls_gen2.sh
   ```
3. **Validate outcome**
   - Use the Azure CLI commands printed by the script to observe resources and settings.

## Compliance Notes
> [!IMPORTANT]
> **HIPAA/HITRUST:** Enforce least-privilege. Log access (Module 14), keep audit trails (Module 15), and restrict network exposure (Module 9).
> [!IMPORTANT]
> **Research Data:** Use ADLS ACLs for principle-of-least-privilege on cohort datasets; de-identify data before export.

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
- Module script: `infra/m16_adls_gen2.sh`
- Diagrams: `assets/diagrams/module16_flow.mmd`, `assets/diagrams/module16_sequence.mmd`
- App demo: `app/web/index.php` (SAS uploader), `app/ai/cse_upload.py` (client-side encryption demo)
