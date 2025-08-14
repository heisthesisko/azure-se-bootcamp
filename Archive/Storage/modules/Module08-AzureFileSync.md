
    # Module08: Azure File Sync

    **Top Problems/Features Addressed**
    1. Central cloud repository with local caches.
1. Multi-site sync and cloud tiering.

    **Intent & Learning Objectives**
    - Understand Azure File Sync and when to use it.
    - Deploy and validate using Bash + Azure CLI.
    - Demonstrate three or more core features.

    **Key Features Demonstrated**
    - Deploy Sync Service + Group + Cloud Endpoint.
- Provision Windows VM and install agent.
- Register server and (portal) create server endpoint.

    ## Architecture Diagram
    ```mermaid

flowchart TB
  subgraph OnPrem (Hyper-V)
    Web[(Apache Web)]
    DB[(PostgreSQL)]
    AI[(AI Model Server)]
    VyOS[VyOS VPN]
  end
  subgraph Azure
    VNet["VNet + Subnets"]
    SA["Storage Account (Blob/Files/Queue/Table/ADLS Gen2)"]
    VM["Ubuntu VM"]
    KV["Key Vault"]
    PE["Private Endpoints"]
  end
  Web -->|SAS| SA
  AI -->|Upload + Queue| SA
  DB -->|Logs (Table)| SA
  VyOS -. VPN .- VNet
  VNet --> PE --> SA
  VM --> SA

    ```

    > [!IMPORTANT]
    > Run `bash scripts/00_prereqs.sh` then `bash scripts/01_storage_account.sh` before this module (unless this *is* Module 01).

    ## Lab Steps
    1. Load environment and login:
       ```bash
       source config/env.sh
       az login
       az account set --subscription "$SUBSCRIPTION_ID"
       ```
    2. Execute scripts for this module:
       - `scripts/08_file_sync.sh`


> [!CAUTION]
> Azure File Sync is **Windows-only** for the on-prem/edge agent. This module provisions a Windows Server VM in Azure for the demo using `az vm run-command` with PowerShell. You may alternatively use a Hyper‑V Windows Server if available.


    ## Validation
    - Use `az ... show/list` commands included in scripts to confirm success.
    - If something fails, re-run with `bash -x` for verbose output.

    ## Cleanup
    - Continue to the next module, or remove all resources at the end with `bash scripts/99_cleanup.sh`.

    ## Pros, Cons & Insights
    - **Pros:** Native Azure capabilities, automation via CLI.
    - **Cons:** Regional/SKU limitations may apply; quotas can block certain features.
    - **Insight:** Keep infrastructure idempotent—rerunning scripts should not break your environment.

    > [!CAUTION]
    > Some modules (e.g., File Sync, ANF) require specific quotas/regions. If blocked, read the module notes for alternatives.

    > [!TIP]
    > Store your `config/env.sh` with non-secret values; keep secrets out or use Key Vault.
