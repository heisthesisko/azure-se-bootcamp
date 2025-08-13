# Module 20: Centralized Monitoring & Reporting

    ### Intent & Learning Objectives
    - Understand **Centralized Monitoring & Reporting** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - End-to-end visibility post-migration.
- Operational KPIs & compliance dashboards.

    ### Core Features Demonstrated
    - Log Analytics workspace
- Workbook dashboards
- Alert rules (KQL)

    > [!IMPORTANT]
    > Protect logs (they may contain identifiers); use retention and access policies.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  Logs --> LA[Log Analytics]
  LA --> Workbooks
  LA --> Alerts
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant Ops as Operations
  participant M as Azure Monitor
  Ops->>M: Query KQL
  M-->>Ops: Dashboard render
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `infra/17_monitoring_dashboard.sh`
       - Follow on-screen prompts or review the scripts before execution.
    4. Route logs to secure archive per policy.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
