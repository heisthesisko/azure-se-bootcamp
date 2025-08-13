# Module 2: Arc-Enabled Servers

> [!IMPORTANT]
> Use synthetic ePHI; follow least privilege RBAC; record evidence for audits.

## Intent & Learning Objectives
Onboard Linux/Windows servers anywhere to Azure using the Arc Connected Machine agent; enable extensions for monitoring and security.

## Top Problems Solved
1. No single pane of glass for physical/legacy servers handling ePHI.
2. Agent sprawl and inconsistent monitoring/AV on on‑prem servers.

## Key Features Demonstrated
- Install Arc agent (Linux & Windows).
- Onboard via Service Principal for scale.
- Deploy extensions (Azure Monitor agent) from Azure.

## Architecture Diagram
See `assets/diagrams/module02_flow.mmd`.

## Step-by-Step

1. Create SP: `az ad sp create-for-rbac --role "Azure Connected Machine Onboarding" --scopes /subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$ARC_RG_SERVERS`.
2. Linux install: `curl -fsSL https://aka.ms/InstallAzureArcAgent | bash` then `azcmagent connect --resource-group $ARC_RG_SERVERS --tenant-id $AZ_TENANT_ID --subscription-id $AZ_SUBSCRIPTION_ID --location $AZ_LOCATION --service-principal-id $ARC_SP_CLIENT_ID --service-principal-secret $ARC_SP_CLIENT_SECRET --resource-name OnPrem-$(hostname)`.
3. Verify in Portal: Azure Arc ➜ Servers (status **Connected**); add tags (`Role=Database`, `Compliance=HIPAA`).
4. Add Azure Monitor Agent via **Extensions + applications** and link to Log Analytics workspace.
5. Use **Run Command** to execute a health check (e.g., `uptime`) from Azure.


## Pros, Cons & Warnings
- **Pros:** Fast onboarding; enables policy, monitoring, Defender for on‑prem servers.
- **Cons:** Relies on agent connectivity; run‑command grants high power—assign roles carefully.
> [!CAUTION]
> Treat SP secrets like credentials; rotate or delete after onboarding.

> [!TIP]
> Automate bulk onboarding with a simple shell loop over hostnames.
