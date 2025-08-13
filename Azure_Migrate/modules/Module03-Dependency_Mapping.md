# Module 3: Dependency Mapping

    ### Intent & Learning Objectives
    - Understand **Dependency Mapping** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Hard to understand inter-service call paths.
- Risk of breaking clinical workflows.

    ### Core Features Demonstrated
    - Enable dependency agent
- Build service map
- Derive migration groups

    > [!IMPORTANT]
    > Service map helps isolate **PHI flows**. Use tagging to mark systems interacting with ePHI.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  Web[(Web: Apache/PHP)] --> DB[(PostgreSQL)]
  AI[(AI Service)] --> DB
  Users --> Web
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant U as Clinician
  participant Web as Web App
  participant DB as PostgreSQL
  U->>Web: HTTP GET /patients
  Web->>DB: SELECT * FROM patients
  DB-->>Web: Rows
  Web-->>U: Render page
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: (Portal-driven)
       - Follow on-screen prompts or review the scripts before execution.
    4. Capture a screenshot of the dependency map and store in assets/images/.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
