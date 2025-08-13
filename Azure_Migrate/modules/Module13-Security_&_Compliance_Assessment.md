# Module 13: Security & Compliance Assessment

    ### Intent & Learning Objectives
    - Understand **Security & Compliance Assessment** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Prove HIPAA/HITRUST alignment.
- Enforce guardrails at scale.

    ### Core Features Demonstrated
    - Azure Policy assignments
- Defender for Cloud
- Regulatory compliance dashboard

    > [!IMPORTANT]
    > Use policy initiatives mapped to HIPAA/HITRUST controls.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  Policies --> Subscriptions --> Compliance[Regulatory Score]
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant Sec as Security
  participant P as Azure Policy
  Sec->>P: Assign HIPAA policy set
  P-->>Sec: Noncompliant resources list
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `infra/09_enable_security.sh`
       - Follow on-screen prompts or review the scripts before execution.
    4. Remediate with change records; track exceptions formally.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
