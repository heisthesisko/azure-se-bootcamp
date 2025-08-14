# Module 4: Alerts and Notifications

**Intent & Learning Objectives:**  
This module explains **Automated alerts for performance, security, and compliance events.** in the context of healthcare (providers and payors). By the end, you will:  
- Understand the core concepts and **three key features** of Alerts and Notifications.  
- Deploy and configure Azure resources via **Bash (Azure CLI)** from VS Code.  
- Validate telemetry using **KQL** and visualize with **Azure Monitor**.

**Top Two Problems / Features**  
1. **Problem/Feature A:** Metric alerts (e.g., CPU) and log search alerts (e.g., failed logins).  
2. **Problem/Feature B:** Action Groups for email/SMS/webhook and future automation.

> [!IMPORTANT]
> Treat all lab data as ePHI. Use only **synthetic** data. Apply least-privilege RBAC on Log Analytics and dashboards.

**Architecture Diagram**  
See: `assets/diagrams/module04_flow.mmd` and `assets/diagrams/module04_sequence.mmd`.

```mermaid
flowchart LR
  A["Module 4: Alerts and Notifications"] --> B["Azure Monitor"]
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
   bash infra/05_create_alerts.sh
   ```

3. **Validate in Portal/KQL**  
   Example KQL:
   ```kusto
   Syslog | where LogMessage contains 'Failed password' | summarize count() by bin(TimeGenerated, 5m)
   ```

4. **(Optional) Alerting/Visualization**  
   - Pin a chart to dashboard or create an alert as described in the module.

> [!CAUTION]
> Verify resource **locations** and **quotas**. Monitoring data at rest may be subject to org retention policy.

## Pros, Cons & Insights
**Pros:** Proactive detection; reduces MTTD.  
**Cons:** Alert fatigue if thresholds are noisy.  
**Insights:** Prefer dynamic thresholds and grouped alerts where possible.

## Compliance Notes
- **HIPAA/HITRUST:** Use Log Analytics RBAC; retain logs per policy (e.g., 90–365+ days).  
- **FHIR/DICOM:** Avoid placing PHI in diagnostic messages; instrument at metadata level if possible.  
- **Auditability:** Export Activity Logs and App logs for long-term archival if required.

> [!TIP]
> Commit your scripts/diagrams to source control and track changes like any production IaC.
