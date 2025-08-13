# Module 19: Data Governance with Microsoft Purview

    ### Intent & Learning Objectives
    - Understand **Data Governance with Microsoft Purview** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Know where PHI lives.
- Automate classification & lineage.

    ### Core Features Demonstrated
    - Scan storage/DBs
- Healthcare classifiers
- Access reviews/lineage

    > [!IMPORTANT]
    > Use built-in PHI/FHIR/DICOM classifiers; review false positives.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  Purview --> Scans --> Inventory
  Inventory --> Lineage
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant Gov as Governance
  participant PV as Purview
  Gov->>PV: Schedule scans
  PV-->>Gov: Classified assets
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `infra/16_purview_setup.sh`
       - Follow on-screen prompts or review the scripts before execution.
    4. Apply access policies & data owner assignments.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
