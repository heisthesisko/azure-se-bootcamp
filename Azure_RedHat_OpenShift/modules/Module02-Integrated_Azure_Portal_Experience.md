# Module 2: Integrated Azure Portal Experience

**Intent & Learning Objectives:** Hands-on introduction to **Integrated Azure Portal Experience** for healthcare workloads (HIPAA/HITRUST/FHIR/DICOM). You will start from zero and finish with a working, validated configuration.

> [!IMPORTANT]
> Top two problems this module solves: **Unified management UI**, **Integrated monitoring**.

**Key Features Demonstrated:** At least three core capabilities of integrated azure portal experience with step-by-step labs and verification.

## Architecture Diagram
```mermaid
%% assets/diagrams/module02_flow.mmd
flowchart TB
  A["Module 02 Start"] --> B["Core Step"]
  B --> C["Result"]

```

## Sequence Diagram
```mermaid
%% assets/diagrams/module02_sequence.mmd
sequenceDiagram
  participant U as User
  participant S as Service
  U->>S: Module 02 request
  S-->>U: Response

```

## Step-by-Step
1. **Prepare Environment**  
   ```bash
   source config/.env
   ```
2. **Execute Core Script(s) / Commands**  
   ```bash
   # Scripts: Portal steps; no script
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

