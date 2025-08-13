# Module 4: Assessment & Readiness Analysis

    ### Intent & Learning Objectives
    - Understand **Assessment & Readiness Analysis** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Over/under-sizing costs and performance issues.
- Legacy OS and DB compatibility.

    ### Core Features Demonstrated
    - Right-size recommendations
- Readiness reports
- Remediation plan export

    > [!IMPORTANT]
    > Export reports without patient data; share with CAB for review.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  Inventory --> Assessment[Assessment]
  Assessment --> Sizing
  Assessment --> Readiness
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant M as Azure Migrate
  participant Eng as Engineer
  Eng->>M: Run assessment
  M-->>Eng: Sizing & readiness
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `infra/03_run_assessment.sh`
       - Follow on-screen prompts or review the scripts before execution.
    4. Review assessment CSVs in assets/docs/ for blockers.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
