# Module 16: Application Modernization Tools

    ### Intent & Learning Objectives
    - Understand **Application Modernization Tools** in the context of healthcare migrations.
    - Learn to apply this capability to protect ePHI under **HIPAA** while aligning to **FHIR/DICOM** where relevant.
    - Perform hands-on tasks using Azure CLI (bash) from VS Code.

    ### Top Problems/Features Addressed
    - Reduce infra toil; increase agility.
- Adopt AKS/Functions microservices.

    ### Core Features Demonstrated
    - Containerize AI service
- Deploy to AKS
- Private networking (CNI)

    > [!IMPORTANT]
    > Use private clusters and Azure CNI; egress via Firewall.

    ### Architecture Diagram – Flow
    ```mermaid
flowchart TB
  Code --> Container --> AKS
  AKS --> Users
```

    ### Sequence Diagram – Operations
    ```mermaid
sequenceDiagram
  participant Dev as Dev
  participant A as AKS
  Dev->>A: kubectl apply
  A-->>Dev: Service available
```

    ### Step-by-Step Instructions
    1. **Open VS Code** and open the integrated terminal (bash). Ensure Azure CLI is installed and authenticated: `az login`.
    2. **Load environment**: `set -a; source config/.env; set +a` (after you copied from `env.sample`).
    3. **Run scripts**: `infra/12_containerize_ai.sh` `infra/13_deploy_aks.sh`
       - Follow on-screen prompts or review the scripts before execution.
    4. Scan images (ACR Tasks/Defender) before deploy.

    ### Pros, Cons & Insights
    - **Pros:** Healthcare-aligned, supports secure migration patterns, integrates with Azure governance.
    - **Cons:** Requires planning, role coordination, and change control windows in clinical environments.
    - **Insights:** Treat the migration plan as a **clinical change**—validate with CAB and ensure rollback criteria align with patient safety.

    > [!CAUTION]
    > Validate that **no real PHI** is present in lab data. Confirm encryption in transit (VPN/TLS) and at rest before moving any sample records.

    > [!TIP]
    > Keep a running log of commands and outcomes in `assets/docs/lab-notes.md` for audit trails.
