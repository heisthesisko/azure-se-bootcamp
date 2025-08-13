# Module 11: Minimal-Downtime Cutover

    ### Intent & Learning Objectives
    - Understand **Minimal-Downtime Cutover** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Near-zero downtime for clinical systems.
- Clear rollback if issues arise.

    ### Core Features Demonstrated
    - Continuous replication
- Finalize DNS cuts
- Health validation

    > [!IMPORTANT]
    > Notify clinicians/stakeholders of maintenance windows.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart LR
  Replication --> FinalSync --> Cutover
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant M as Migrate Tooling
  participant N as Network/DNS
  M->>N: Update records
  N-->>M: Propagation complete
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: (Portal-driven)
       - Follow on-screen prompts or review the scripts before execution.
    4. Document rollback triggers and steps alongside cutover plan.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
