# Module 19: AI/ML Integration (OpenShift AI, Azure AI)

**Intent & Learning Objectives:** Hands-on introduction to **AI/ML Integration (OpenShift AI, Azure AI)** for healthcare workloads (HIPAA/HITRUST/FHIR/DICOM). You will start from zero and finish with a working, validated configuration.

> [!IMPORTANT]
> Top two problems this module solves: **Scalable inference**, **Model lifecycle**.

**Key Features Demonstrated:** At least three core capabilities of ai/ml integration (openshift ai, azure ai) with step-by-step labs and verification.

## Architecture Diagram
```mermaid
%% assets/diagrams/module19_flow.mmd
flowchart TB
  A["Module 19 Start"] --> B["Core Step"]
  B --> C["Result"]

```

## Sequence Diagram
```mermaid
%% assets/diagrams/module19_sequence.mmd
sequenceDiagram
  participant U as User
  participant S as Service
  U->>S: Module 19 request
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

### Cloud AI Workloads in this Module
- **TensorFlow**: `app/ai/tensorflow_infer.py` (CPU demo).  
- **Hugging Face**: `app/ai/hf_analysis.py` (downloads model on first run).  
> [!TIP] Run these in a GPU-enabled node pool for real workloads.
