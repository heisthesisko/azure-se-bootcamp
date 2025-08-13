# Module 9: Web App Migration Assistant

    ### Intent & Learning Objectives
    - Understand **Web App Migration Assistant** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Migrate PHP/.NET apps to App Service.
- Reduce OS patching overhead.

    ### Core Features Demonstrated
    - App Service plan
- Web app deploy
- App settings/connection strings

    > [!IMPORTANT]
    > Enforce HTTPS-only and TLS1.2+ on App Service.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  Code --> AppService
  AppService --> Users
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant Dev as Dev
  participant AS as App Service
  Dev->>AS: Deploy zip
  AS-->>Dev: URL ready
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `infra/07_web_app_migration.sh`
       - Follow on-screen prompts or review the scripts before execution.
    4. Rotate connection strings using Key Vault (optional).

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
