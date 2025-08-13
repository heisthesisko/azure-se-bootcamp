# Module 8: Database Migration Service Integration

    ### Intent & Learning Objectives
    - Understand **Database Migration Service Integration** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Move Postgres/SQL with minimal downtime.
- Preserve integrity of clinical data.

    ### Core Features Demonstrated
    - DMS project
- Online migration
- Data validation

    > [!IMPORTANT]
    > Mask PHI in lower environments; use TLS for DB endpoints.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  OnPremDB[(PostgreSQL)] -->|DMS| AzureDB[(Azure Database for PostgreSQL)]
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant D as DMS
  participant DBA as DBA
  DBA->>D: Configure online migration
  D-->>DBA: Sync status
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `infra/06_database_migration.sh`
       - Follow on-screen prompts or review the scripts before execution.
    4. Run post‑migration checks comparing row counts and checksums.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
