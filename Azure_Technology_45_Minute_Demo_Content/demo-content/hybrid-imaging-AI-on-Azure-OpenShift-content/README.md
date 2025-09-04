# Imaging Platform Deployment Files

This bundle contains:
- **presentation/Hybrid-Imaging-AI-on-Azure-OpenShift.md** — 45‑minute Markdown presentation with Mermaid diagrams.
- **bicep/storage.bicep** — Storage account + `dicom` container (secure defaults; immutability via script).
- **bicep/azureml.bicep** — Azure ML workspace with public network access disabled and encryption enabled.
- **scripts/deploy_model.sh** — Registers a model and deploys an AML online endpoint (private).
- **scripts/deploy_batch_job.sh** — Creates Azure Batch account/pool and submits a sample job.
- **scripts/connect_openshift.sh** — Onboard OpenShift to Azure Arc.
- **scripts/set_immutability.sh** — Apply WORM policy/legal hold on the `dicom` container.
- **scripts/azcopy_sync.sh** — Example sync of a local PACS export folder to Blob using AzCopy.
- **openshift/orthanc/** — Minimal Orthanc DICOM archive demo (PVC, ConfigMap, Deployment, Service, Route).

> **Note:** Replace placeholders (resource names, regions, image references) before deploying. Configure **Private Endpoints** and DNS for Storage/AML to ensure no public egress. For a production PACS (e.g., DCM4CHEE), adapt manifests accordingly and use a managed database.

## Quick Start
```bash
# 1) Deploy storage + container
az group create -n ImagingRG -l eastus
az deployment group create -g ImagingRG -f bicep/storage.bicep -p storageAccountName=<youruniqueSA>

# 2) Set immutability policy
./scripts/set_immutability.sh  # set SA_NAME and desired retention first

# 3) Deploy AML workspace
az deployment group create -g ImagingRG -f bicep/azureml.bicep

# 4) Deploy model endpoint
./scripts/deploy_model.sh  # set MODEL_PATH etc.

# 5) Azure Batch demo (optional)
./scripts/deploy_batch_job.sh

# 6) Connect OpenShift to Azure Arc
./scripts/connect_openshift.sh
```

## OpenShift Orthanc Demo
```bash
oc apply -f openshift/orthanc/orthanc.yaml
# Access web UI via the created Route; send DICOM via AE=ORTHANC on port 4242.
```

## Security Checklist
- Storage: SSE enabled, TLS1.2+, no public access, Private Endpoint, WORM/Legal Hold as needed.
- AML: public network disabled; private endpoints; RBAC; diagnostics.
- Networking: ExpressRoute/VPN; NSGs; private DNS; deny outbound by default where possible.
- OpenShift: FIPS mode; SCC restrict; non‑root pods; image scanning; NetworkPolicies.
- Audit: Centralize logs (Azure Monitor/SIEM), enable K8s audit, review access logs.

