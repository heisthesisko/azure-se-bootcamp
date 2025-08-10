    # Network Security Group (NSG)

    **Intent:** Learn and deploy core features of Network Security Group (NSG). This module builds on previous modules.

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
flowchart TB
Internet --> NSG["NSG rules"]
NSG --> VM["VM1"]
VM --> Internet
```


    **Deploy**
    ```bash
    bash infra/infra/m02_nsg.sh
    ```

    **Verify**
    - Follow the script output (public IPs, resource names).
    - Test connectivity as directed in the script comments and README.

    **Pros / Cons / Warnings**
    - Pros: Cloud-native, managed, integrates with other Azure services.
    - Cons: Costs may apply; ensure correct NSG/route/DNS configuration.
    - Warning: Always use non-overlapping IP ranges; secure admin access.
