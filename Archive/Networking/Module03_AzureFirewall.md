    # Azure Firewall (Hub/Spoke + UDR)

    **Intent:** Learn and deploy core features of Azure Firewall (Hub/Spoke + UDR). This module builds on previous modules.

    **What you'll learn**
    - Key concepts and design.
    - Step-by-step deployment with Azure CLI (Bash).
    - Verification tests, pros/cons, and gotchas.

    **Prerequisites**
    - VS Code on Windows.
    - Azure CLI authenticated (`Azure: Login` task) and `config/env.sh` customized.
    - Resource group: `${WORKSHOP_RG}` in location `${WORKSHOP_LOCATION}`.

    **Diagram**
    ```mermaid
flowchart LR
subgraph Hub
  FW["Azure Firewall"]
end
subgraph Spoke
  VM["VM1"]
end
Internet --> FW --> VM
VM --> FW --> Internet
```


    **Deploy**
    ```bash
    bash infra/infra/m03_firewall.sh
    ```

    **Verify**
    - Follow the script output (public IPs, resource names).
    - Test connectivity as directed in the script comments and README.

    **Pros / Cons / Warnings**
    - Pros: Cloud-native, managed, integrates with other Azure services.
    - Cons: Costs may apply; ensure correct NSG/route/DNS configuration.
    - Warning: Always use non-overlapping IP ranges; secure admin access.
