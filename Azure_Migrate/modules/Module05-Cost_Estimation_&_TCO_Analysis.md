# Module 5: Cost Estimation & TCO Analysis

    ### Intent & Learning Objectives
    - Understand **Cost Estimation & TCO Analysis** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Unclear cost model post-migration.
- Budget alignment for payor/provider ops.

    ### Core Features Demonstrated
    - Export cost estimates
- Model reservations/ savings
- TCO comparison

    > [!IMPORTANT]
    > Never store patient identifiers in cost artifacts.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart LR
  OnPremCosts -->|Compare| AzureCosts
  AzureCosts --> TCO[TCO Report]
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant C as Cost Tool
  participant U as User
  U->>C: Export estimates
  C-->>U: CSV for finance
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `infra/04_export_costs.sh`
       - Follow on-screen prompts or review the scripts before execution.
    4. Share TCO files with finance using secure channels.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
