# Module 20: Automated Remediation

**Intent & Learning Objectives:**  
This module explains **Logic Apps/Runbooks to auto-resolve monitored issues.** in the context of healthcare (providers and payors). By the end, you will:  
- Understand the core concepts and **three key features** of Automated Remediation.  
- Deploy and configure Azure resources via **Bash (Azure CLI)** from VS Code.  
- Validate telemetry using **KQL** and visualize with **Azure Monitor**.

**Top Two Problems / Features**  
1. **Problem/Feature A:** Logic Apps/Runbooks triggered by alerts.  
2. **Problem/Feature B:** Self-healing (scale, isolate, ticket).

> [!IMPORTANT]
> Treat all lab data as ePHI. Use only **synthetic** data. Apply least-privilege RBAC on Log Analytics and dashboards.

**Architecture Diagram**  
See: `assets/diagrams/module20_flow.mmd` and `assets/diagrams/module20_sequence.mmd`.

```mermaid
flowchart LR
  A["Module 20: Automated Remediation"] --> B["Azure Monitor"]
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
   bash infra/20_automated_response.sh
   ```

3. **Validate in Portal/KQL**  
   Example KQL:
   ```kusto
   // Trigger conditions defined in alert rules (see Module 4 & 19).
   ```

4. **(Optional) Alerting/Visualization**  
   - Pin a chart to dashboard or create an alert as described in the module.

> [!CAUTION]
> Verify resource **locations** and **quotas**. Monitoring data at rest may be subject to org retention policy.

## Pros, Cons & Insights
**Pros:** Reduces toil; faster recovery.  
**Cons:** Risk of over-automation; need guardrails.  
**Insights:** Start read-only (notify/ticket) before write actions.

## Compliance Notes
- **HIPAA/HITRUST:** Use Log Analytics RBAC; retain logs per policy (e.g., 90–365+ days).  
- **FHIR/DICOM:** Avoid placing PHI in diagnostic messages; instrument at metadata level if possible.  
- **Auditability:** Export Activity Logs and App logs for long-term archival if required.

> [!TIP]
> Commit your scripts/diagrams to source control and track changes like any production IaC.
