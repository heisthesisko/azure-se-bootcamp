# Module 11: Workbooks

**Intent & Learning Objectives:**  
This module explains **Interactive analytics combining metrics and logs for healthcare teams.** in the context of healthcare (providers and payors). By the end, you will:  
- Understand the core concepts and **three key features** of Workbooks.  
- Deploy and configure Azure resources via **Bash (Azure CLI)** from VS Code.  
- Validate telemetry using **KQL** and visualize with **Azure Monitor**.

**Top Two Problems / Features**  
1. **Problem/Feature A:** Interactive reports with parameters and rich visuals.  
2. **Problem/Feature B:** Combine metrics & logs for clinical ops views.

> [!IMPORTANT]
> Treat all lab data as ePHI. Use only **synthetic** data. Apply least-privilege RBAC on Log Analytics and dashboards.

**Architecture Diagram**  
See: `assets/diagrams/module11_flow.mmd` and `assets/diagrams/module11_sequence.mmd`.

```mermaid
flowchart LR
  A["Module 11: Workbooks"] --> B["Azure Monitor"]
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
   # Workbook via Portal (no script)
   ```

3. **Validate in Portal/KQL**  
   Example KQL:
   ```kusto
   union requests, Syslog | summarize count() by bin(TimeGenerated, 1h)
   ```

4. **(Optional) Alerting/Visualization**  
   - Pin a chart to dashboard or create an alert as described in the module.

> [!CAUTION]
> Verify resource **locations** and **quotas**. Monitoring data at rest may be subject to org retention policy.

## Pros, Cons & Insights
**Pros:** Highly customizable and shareable analytics.  
**Cons:** Manual design effort; versioning via JSON export.  
**Insights:** Standardize workbooks per app/service; store JSON in repo.

## Compliance Notes
- **HIPAA/HITRUST:** Use Log Analytics RBAC; retain logs per policy (e.g., 90–365+ days).  
- **FHIR/DICOM:** Avoid placing PHI in diagnostic messages; instrument at metadata level if possible.  
- **Auditability:** Export Activity Logs and App logs for long-term archival if required.

> [!TIP]
> Commit your scripts/diagrams to source control and track changes like any production IaC.
