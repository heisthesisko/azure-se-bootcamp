# Module 17: Integration with Microsoft Cloud for Healthcare

    ### Intent & Learning Objectives
    - Understand **Integration with Microsoft Cloud for Healthcare** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Standardize data on FHIR/DICOM.
- Enable patient 360 and imaging.

    ### Core Features Demonstrated
    - Deploy Health Data Services
- FHIR service + DICOM
- Ingestion pipelines

    > [!IMPORTANT]
    > HDS is HIPAA-eligible and supports FHIR R4 and DICOMweb APIs.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  EHR --> FHIR --> HDS[Health Data Services]
  PACS --> DICOM --> HDS
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant ETL as Ingestion
  participant F as FHIR
  participant D as DICOM
  ETL->>F: Upsert resources
  ETL->>D: Store studies/series
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `infra/14_deploy_health_data_services.sh`
       - Follow on-screen prompts or review the scripts before execution.
    4. Use synthetic FHIR bundles and de‑identified DICOM.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
