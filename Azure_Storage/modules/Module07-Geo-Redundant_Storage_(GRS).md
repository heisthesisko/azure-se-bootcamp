# Module 07: Geo-Redundant Storage (GRS)
**Intent & Learning Objectives:** Enable cross-region durability and optional read access (RA-GRS).

**Top 2 problems this solves / features provided:**
- Sustain regional outages
- Optional read from secondary

**Key Features Demonstrated:**
- Change SKU to RA-GRS; understand RPO/RTO tradeoffs

**Architecture Diagram (module-specific)**
```mermaid
flowchart LR
  Primary["Primary Region
(Storage Account)"] -->|Async Replication| Secondary["Secondary Region"]
  User --> Primary
  Reader["Read-Only Clients"] -. RA-GRS .-> Secondary

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant Client
  participant Primary
  participant Secondary
  Client->>Primary: Read/Write
  Primary-->>Secondary: Async replicate
  Client->>Secondary: Read (RA-GRS)
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
   bash infra/m07_grs.sh
   ```
   - Query account properties to see secondary endpoints.
   - Test read from `-secondary` endpoint (if enabled).

## Compliance Notes
- **DR plan:** Document failover/CRR procedures.
- **Data residency:** Align with policy.

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
- Script: `infra/m07_grs.sh`
