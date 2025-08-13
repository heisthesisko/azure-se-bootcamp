# Module 6: Migration Planning & Wave Scheduling

    ### Intent & Learning Objectives
    - Understand **Migration Planning & Wave Scheduling** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Need phased cutovers during clinical low-traffic windows.
- Reduce risk across EHR/ancillary systems.

    ### Core Features Demonstrated
    - Wave definition
- Runbooks/rollback
- Change calendar integration

    > [!IMPORTANT]
    > Plan blackout windows around clinical operations (e.g., nights/weekends).

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  subgraph Plan
    Waves[Waves] --> Runbooks
    Runbooks --> ChangeCalendar
  end
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant PM as Project Manager
  participant CAB as Change Board
  PM->>CAB: Submit migration wave
  CAB-->>PM: Approved window
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: (Portal-driven)
       - Follow on-screen prompts or review the scripts before execution.
    4. Store approved wave plan in assets/docs/wave_plan.md.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
