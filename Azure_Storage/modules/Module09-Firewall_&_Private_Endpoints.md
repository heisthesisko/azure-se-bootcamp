# Module 09: Firewall & Private Endpoints
**Intent & Learning Objectives:** Eliminate public network access to ePHI containers.

**Top 2 problems this solves / features provided:**
- Zero public exposure
- Private DNS resolution within VNet

**Key Features Demonstrated:**
- DefaultAction=Deny; Private Endpoint; Private DNS zone link

**Architecture Diagram (module-specific)**
```mermaid
flowchart TB
  subgraph VNet
    Subnet["Subnet: snet-app"]
    PE["Private Endpoint (blob)"]
  end
  AppVM["App VM"] -->|HTTPS| PE --> SA["Storage Account"]
  X["Internet"] -.-x SA
  DNS["Private DNS Zone"] --> PE

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant AppVM
  participant PE as Private Endpoint
  participant SA as Storage
  AppVM->>PE: HTTPS
  PE->>SA: Private link
  SA-->>AppVM: Data
  Note over SA: Public access denied
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
   bash infra/m09_firewall_pe.sh
   ```
   - From a VM in VNet, access blob; from Internet, confirm blocked.

## Compliance Notes
- **ePHI isolation:** Only private IP paths.
- **Name resolution:** Ensure DNS forwarding for on-prem if needed.

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
- Script: `infra/m09_firewall_pe.sh`
