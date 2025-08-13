# Module 18: AI & Analytics Enablement

    ### Intent & Learning Objectives
    - Understand **AI & Analytics Enablement** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Turn data into insights.
- Operationalize ML responsibly.

    ### Core Features Demonstrated
    - Synapse/Fabric workspace
- Link to data sources
- Notebook/ML pipeline

    > [!IMPORTANT]
    > De-identify before model training; differential privacy where feasible.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  DataLake --> Synapse --> Reports
  Synapse --> ML
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant DS as Data Scientist
  participant S as Synapse
  DS->>S: Run notebook
  S-->>DS: Curated dataset
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `infra/15_enable_analytics.sh`
       - Follow on-screen prompts or review the scripts before execution.
    4. Log model lineage and datasets for audit.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
