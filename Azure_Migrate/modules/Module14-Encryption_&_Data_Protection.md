# Module 14: Encryption & Data Protection

    ### Intent & Learning Objectives
    - Understand **Encryption & Data Protection** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Encrypt data in transit and at rest.
- Manage keys and rotation.

    ### Core Features Demonstrated
    - CMK for disks
- TLS for services
- Double encryption options

    > [!IMPORTANT]
    > Separate key admin from data admin roles for SoD.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  Keys[Key Vault/Managed HSM] --> Disks
  Keys --> AppService
  Keys --> Databases
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant K as Key Vault
  participant S as Service
  S->>K: Get key
  S-->>S: Encrypt data
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `infra/10_configure_encryption.sh`
       - Follow on-screen prompts or review the scripts before execution.
    4. Test restores with CMK to avoid vendor lock‑in surprises.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
