# HL7 → FHIR Interoperability Demo (Azure)

## Contents
- `Hybrid-HL7-FHIR-Interop-on-Azure.md` — 45‑minute presentation with Mermaid diagrams and runbook.
- `bicep/main.bicep` — Deploy **Azure API for FHIR** + **APIM** (+ optional Private Endpoint/DNS).
- `logicapp/hl7_to_fhir_logicapp.json` — Logic App workflow for HL7→FHIR using `$convert-data`.
- `apim/policies/fhir-inbound-policy.xml` — APIM inbound policy (JWT validation + rate limit).
- `k8s/aro-mllp-bridge.yaml` — OpenShift/K8s MLLP→HTTP bridge manifest.
- `scripts/deploy.sh`, `scripts/deploy.ps1` — One‑shot deployment scripts.

## Quick start
```bash
cd hl7-fhir-azure-demo
bash ./scripts/deploy.sh
```
Then import APIM policy and test the Logic App trigger with a sample ADT message.

> Production notes: Use APIM Premium with VNET/Private Link; enable CMK for FHIR; enforce Azure Policy (HIPAA/HITRUST); wire diagnostics to Log Analytics; keep all PHI on private endpoints/VPN/ER.
