# Module 6: Role-Based Access Control (RBAC)

**Intent & Learning Objectives:** Hands-on introduction to **Role-Based Access Control (RBAC)** for healthcare workloads (HIPAA/HITRUST/FHIR/DICOM). You will start from zero and finish with a working, validated configuration.

> [!IMPORTANT]
> Top two problems this module solves: **Least privilege**, **Multi-tenancy isolation**.

**Key Features Demonstrated:** At least three core capabilities of role-based access control (rbac) with step-by-step labs and verification.

## Architecture Diagram
```mermaid
%% assets/diagrams/module06_flow.mmd
flowchart TB
  A["Module 06 Start"] --> B["Core Step"]
  B --> C["Result"]

```

## Sequence Diagram
```mermaid
%% assets/diagrams/module06_sequence.mmd
sequenceDiagram
  participant U as User
  participant S as Service
  U->>S: Module 06 request
  S-->>U: Response

```

## Step-by-Step
1. **Prepare Environment**  
   ```bash
   source config/.env
   ```
2. **Execute Core Script(s) / Commands**  
   ```bash
   # Scripts: See repo scripts referenced in steps
   # (See comments inside each script for parameters and prerequisites)
   ```
3. **Validate**  
   Use `oc` and portal to verify status. Capture screenshots into `assets/images/` for audit evidence.

> [!CAUTION]
> Delete lab resources after completion to avoid costs. Never test with real PHI.

## Pros, Cons & Insights
- **Pros:** Secure-by-default patterns, Azure/Red Hat managed components, strong auditability.
- **Cons:** Cost of redundancy, learning curve for operators, need for disciplined IAM.
- **Insight:** Map technical controls to HIPAA safeguards (e.g., RBAC ↔ minimum necessary, TLS/mTLS ↔ transmission security).

