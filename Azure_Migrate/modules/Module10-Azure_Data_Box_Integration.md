# Module 10: Azure Data Box Integration

    ### Intent & Learning Objectives
    - Understand **Azure Data Box Integration** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Bulk ingest of imaging (DICOM) & archives.
- Limited network bandwidth.

    ### Core Features Demonstrated
    - Order Data Box
- Copy data securely
- Chain-of-custody

    > [!IMPORTANT]
    > Data Box is HIPAA-eligible; encrypts data at rest; maintain custody logs.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  PACS[(On-Prem PACS)] --> DataBox
  DataBox --> AzureStorage[(Azure Storage)]
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant H as Hospital IT
  participant B as Data Box
  H->>B: Copy DICOM files
  B-->>H: Ship to Azure DC
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: (Portal-driven)
       - Follow on-screen prompts or review the scripts before execution.
    4. Store DICOM sample sets only; verify access control once landed.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
