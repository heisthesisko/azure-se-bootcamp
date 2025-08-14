# Module 7: Network Monitoring

**Intent & Learning Objectives:**  
This module explains **Monitor VPN/NSGs/flows and hybrid connectivity with Network Watcher.** in the context of healthcare (providers and payors). By the end, you will:  
- Understand the core concepts and **three key features** of Network Monitoring.  
- Deploy and configure Azure resources via **Bash (Azure CLI)** from VS Code.  
- Validate telemetry using **KQL** and visualize with **Azure Monitor**.

**Top Two Problems / Features**  
1. **Problem/Feature A:** Hybrid connectivity checks (Connection Monitor).  
2. **Problem/Feature B:** NSG Flow Logs + Traffic Analytics.

> [!IMPORTANT]
> Treat all lab data as ePHI. Use only **synthetic** data. Apply least-privilege RBAC on Log Analytics and dashboards.

**Architecture Diagram**  
See: `assets/diagrams/module07_flow.mmd` and `assets/diagrams/module07_sequence.mmd`.

```mermaid
flowchart LR
  A["Module 7: Network Monitoring"] --> B["Azure Monitor"]
  B --> C["Logs/Alerts/Dashboards"]
```
```mermaid
sequenceDiagram
  participant U as User
  participant S as Service
  participant AM as Azure Monitor
  U->>S: Request
  S-->>AM: Telemetry
  AM-->>U: Insight/Alert
```

## Step-by-Step Lab

1. **Prepare environment**  
   ```bash
   cp config/env.sample config/.env
   code config/.env
   bash infra/00_prereqs.sh
   ```

2. **Deploy/Configure**  
   ```bash
   bash infra/08_network_watcher_setup.sh
   ```

3. **Validate in Portal/KQL**  
   Example KQL:
   ```kusto
   AzureNetworkAnalytics_CL | sort by TimeGenerated desc | take 20
   ```

4. **(Optional) Alerting/Visualization**  
   - Pin a chart to dashboard or create an alert as described in the module.

> [!CAUTION]
> Verify resource **locations** and **quotas**. Monitoring data at rest may be subject to org retention policy.

## Pros, Cons & Insights
**Pros:** Assures VPN health; surfaces suspicious flows.  
**Cons:** Flow logs can be heavy; initial setup effort.  
**Insights:** Create alerts on VPN tunnel availability and unusual destinations.

## Compliance Notes
- **HIPAA/HITRUST:** Use Log Analytics RBAC; retain logs per policy (e.g., 90–365+ days).  
- **FHIR/DICOM:** Avoid placing PHI in diagnostic messages; instrument at metadata level if possible.  
- **Auditability:** Export Activity Logs and App logs for long-term archival if required.

> [!TIP]
> Commit your scripts/diagrams to source control and track changes like any production IaC.
