# Module 15: Role-Based Access Control (RBAC)

    ### Intent & Learning Objectives
    - Understand **Role-Based Access Control (RBAC)** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Reduce standing privileges.
- Ensure minimum necessary access.

    ### Core Features Demonstrated
    - Built‑in roles
- Custom role for migration
- PIM JIT access

    > [!IMPORTANT]
    > Never assign **Owner** broadly—use Contributor + specific data roles.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  Users --> Roles --> Scopes
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant GA as Global Admin
  participant IAM as RBAC
  GA->>IAM: Assign roles scoped to RG
  IAM-->>GA: Access granted (JIT)
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `infra/11_rbac_setup.sh` `infra/11_rbac_customrole.sh`
       - Follow on-screen prompts or review the scripts before execution.
    4. Use PIM approvals and time-bound access.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
