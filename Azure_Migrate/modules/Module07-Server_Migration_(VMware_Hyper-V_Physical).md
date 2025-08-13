# Module 7: Server Migration (VMware/Hyper-V/Physical)

    ### Intent & Learning Objectives
    - Understand **Server Migration (VMware/Hyper-V/Physical)** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Move VMs without re-architecture.
- Validate minimal downtime cutovers.

    ### Core Features Demonstrated
    - Agentless replication
- Test migration
- Finalize cutover

    > [!IMPORTANT]
    > Ensure TLS/IPsec during replication. Use non-production PHI-like test data only.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  OnPremVMs --> Replication --> AzureVMs
  AzureVMs --> Cutover
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant E as Engineer
  participant M as Azure Migrate
  E->>M: Enable replication
  M-->>E: Test-migrated VM
  E->>M: Approve cutover
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `infra/05_server_migration.sh`
       - Follow on-screen prompts or review the scripts before execution.
    4. Validate services after test-migration using synthetic health checks.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
