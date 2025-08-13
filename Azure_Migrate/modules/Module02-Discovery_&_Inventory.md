# Module 2: Discovery & Inventory

    ### Intent & Learning Objectives
    - Understand **Discovery & Inventory** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Unknown server estate (Hyper‑V hospital VMs).
- Need inventory without touching PHI.

    ### Core Features Demonstrated
    - Deploy Azure Migrate appliance
- Agentless discovery
- Tag workloads by criticality

    > [!IMPORTANT]
    > Discovery collects **metadata** (no PHI content). Scope access on Hyper‑V to minimum necessary.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  subgraph OnPrem[On-Prem Hospital]
    HV[Hyper-V] --> VMs[(Ubuntu/Rocky VMs)]
    Appliance[Azure Migrate Appliance]
  end
  Appliance -->|Metadata only| AzureMigrate
  AzureMigrate --> Inventory
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant App as Migrate Appliance
  participant OnPrem as Hyper-V
  participant Cloud as Azure Migrate
  App->>OnPrem: Query hosts
  App->>Cloud: Send inventory metadata
  Cloud-->>App: Discovery summary
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `scripts/onprem_hyperv_appliance_setup.ps1`
       - Follow on-screen prompts or review the scripts before execution.
    4. After appliance registration, verify discovered VMs match IPs 192.168.10.10/20/30.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
