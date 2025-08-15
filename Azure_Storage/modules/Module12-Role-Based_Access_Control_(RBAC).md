# Module 12: Role-Based Access Control (RBAC)
**Intent & Learning Objectives:** Grant least-privilege roles at correct scopes.

**Top 2 problems this solves / features provided:**
- Reduce risk of over-permission
- Traceable role assignments

**Key Features Demonstrated:**
- Built-in roles; scope selection; `az role assignment`

**Architecture Diagram (module-specific)**
```mermaid
flowchart TB
  Admin["Storage Admin"] -->|Role Assignment| Scope["Scope: Storage Account/Container"]
  User["Data Analyst"] -->|az login| Entra["Entra ID"]
  Entra -->|AuthZ| SA["Storage"]
  Note["Role: Blob Data Reader/Contributor"]

```

**Sequence Diagram (module-specific)**
```mermaid
sequenceDiagram
  participant Admin
  participant Entra
  participant User
  participant SA as Storage
  Admin->>Entra: Assign role at scope
  User->>Entra: az login
  User->>SA: az storage blob list --auth-mode login
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
   bash infra/m12_rbac.sh
   ```
   - Grant a user Reader; validate `az storage blob list --auth-mode login`.

## Compliance Notes
- **PIM:** Use just-in-time elevation.
- **Scopes:** Prefer container-level where possible.

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
- Script: `infra/m12_rbac.sh`
