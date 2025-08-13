# Module 1: Unified Azure Migrate Portal

    ### Intent & Learning Objectives
    - Understand **Unified Azure Migrate Portal** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Fragmented tooling for discovery and migration.
- Lack of end-to-end visibility for healthcare migrations.

    ### Core Features Demonstrated
    - Create Azure Migrate project
- Navigate discovery/assessment
- Track waves and cutovers

    > [!IMPORTANT]
    > Use **test datasets**. Azure Migrate project metadata does not contain PHI; still, enforce least privilege.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  User --> Portal
  Portal -->|Create Project| AzureMigrate
  AzureMigrate -->|Track| Reports
  subgraph Azure
    AzureMigrate[Azure Migrate]
  end
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant U as User
  participant P as Azure Migrate Portal
  participant A as Azure
  U->>P: Create project
  P->>A: Initialize resources
  A-->>P: Project ready
  P-->>U: Show dashboards
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `infra/01_create_rg_vnet.sh` `infra/02_deploy_vpn_gateway.sh`
       - Follow on-screen prompts or review the scripts before execution.
    4. Browse to the Azure Migrate blade in the portal and verify your project appears.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
