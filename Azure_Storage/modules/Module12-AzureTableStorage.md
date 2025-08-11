
    # Module12: Azure Table Storage

    **Top Problems/Features Addressed**
    1. Low-cost schema-less KV store.
1. Good for telemetry/logs.

    **Intent & Learning Objectives**
    - Understand Azure Table Storage and when to use it.
    - Deploy and validate using Bash + Azure CLI.
    - Demonstrate three or more core features.

    **Key Features Demonstrated**
    - Create table.
- Insert entities.
- Query by PartitionKey.

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
       - `scripts/12_table_storage.sh`



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
