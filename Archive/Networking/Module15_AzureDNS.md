# Azure DNS (Public & Private)

**Intent:** Learn and deploy core features of Azure DNS (Public & Private). This module builds on previous modules.

**What you'll learn**
- Key concepts and design.
- Step-by-step deployment with Azure CLI (Bash).
- Verification tests, pros/cons, and gotchas.

**Prerequisites**
- VS Code on Windows.
- Azure CLI authenticated (`Azure: Login` task) and `config/env.sh` customized.
- Resource group: `${WORKSHOP_RG}` in location `${WORKSHOP_LOCATION}`.

**Diagram**
_See README or in-line notes._


**Deploy**
```bash
bash infra/infra/m15_azure_dns.sh
```

**Verify**
- Follow the script output (public IPs, resource names).
- Test connectivity as directed in the script comments and README.

**Pros / Cons / Warnings**
- Pros: Cloud-native, managed, integrates with other Azure services.
- Cons: Costs may apply; ensure correct NSG/route/DNS configuration.
- Warning: Always use non-overlapping IP ranges; secure admin access.
