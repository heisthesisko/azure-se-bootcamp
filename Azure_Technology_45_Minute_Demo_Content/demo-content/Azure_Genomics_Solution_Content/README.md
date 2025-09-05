# Azure Genomics Solution

This package contains:
- `Azure_Genomics_Presentation.md` — 45‑minute, GitHub‑renderable presentation with Mermaid diagrams.
- `iac/main.bicep` — Bicep skeleton to deploy Key Vault, ADLS Gen2 (CMK), and Synapse.
- `scripts/cli-quickstart.sh` — CLI snippets to stand up the core infra (RG, VNet, Storage, Batch, Synapse, PostgreSQL, Policy).

> All resources are intended for **US regions** and **HIPAA/HITRUST** alignment. Review and edit parameters before running in production.


## New: Cromwell/Nextflow & ARO Manifests
- `workflows/cromwell/simple_alignment.wdl` — WDL sample + `inputs.json` and `cromwell.conf`.
- `workflows/nextflow/main.nf` and `nextflow.config` — Nextflow RNA-seq skeleton with Azure Batch profile.
- `openshift/*.yaml` — ARO manifests: Cromwell Deployment/Service/Route, ConfigMap; Nextflow demo Job; RBAC; Secret placeholders.

### Quick-start on ARO
```bash
oc apply -f openshift/rbac.yaml
oc apply -f openshift/secrets-placeholder.yaml
oc apply -f openshift/cromwell-configmap.yaml
oc apply -f openshift/cromwell-deploy.yaml
oc apply -f openshift/nextflow-job.yaml
```

> Update `secrets-placeholder.yaml` with real Azure Batch/Storage credentials or switch to Managed Identity in your images.


## Wiring Cromwell → Azure Batch + ADLS (end-to-end)
### 1) Create Managed Identity and grant roles
```bash
az deployment group create -g GenomicsRG -f iac/managed-identity.bicep \
  -p storageAccountId=$(az storage account show -g GenomicsRG -n <stg> --query id -o tsv) \
  -p batchAccountId=$(az batch account show -g GenomicsRG -n <batch> --query id -o tsv)
```
### 2) Create Private Endpoints + Private DNS for ADLS
```bash
az deployment group create -g GenomicsRG -f iac/private-endpoints.bicep \
  -p vnetName=GenomicsVNet subnetName=BatchSubnet \
  -p storageAccountId=$(az storage account show -g GenomicsRG -n <stg> --query id -o tsv) \
  -p storageAccountName=<stg>
```
### 3) Mint SAS with MI (time-limited)
```bash
az login --identity  # if running on an Azure VM/Pod with MI
scripts/issue-sas.sh GenomicsRG <stg> cromwell --hours 12 > sas.txt
SAS=$(tail -n1 sas.txt)
```
### 4) Populate secrets & deploy Cromwell on ARO
```bash
oc create secret generic cromwell-azure \
  --from-literal=BATCH_ACCOUNT=<batch> \
  --from-literal=BATCH_URL=https://<region>.batch.azure.com \
  --from-literal=BATCH_KEY=<batch-shared-key-or-empty> \
  --from-literal=STORAGE_ACCOUNT=<stg> \
  --from-literal=STORAGE_CONTAINER=cromwell \
  --from-literal=STORAGE_SAS="$SAS"
oc apply -f openshift/cromwell-configmap.yaml
oc apply -f openshift/cromwell-deploy-azure.yaml
```
> **Prefer Managed Identity?** Cromwell’s native Azure backend may not support AAD/MI directly. For MI-first auth and richer telemetry, consider deploying **Cromwell on Azure (TES)** and point Cromwell to TES; TES uses MI to access Batch/Storage. This repo includes environment prep (PEs, MI, roles). We can add TES manifests on request.



## v4: TES + Workload Identity + Key Vault CSI + Batch Private Endpoint

**New in v4**

- `iac/private-endpoint-batch.bicep` — Private Endpoint + Private DNS for **Azure Batch** account (parametrized groupId).
- `iac/workload-identity.bicep` — Creates **Federated Identity Credential** for your **User-Assigned Managed Identity** (UAMI) to trust a K8s ServiceAccount (`system:serviceaccount:<ns>:<sa>`).
- `openshift/azure-workload-identity.yaml` — Namespace + ServiceAccount (`cromwell-sa`) annotated for **Azure Workload Identity**.
- `openshift/secretproviderclass-kv-cromwell-sas.yaml` — **Secrets Store CSI** `SecretProviderClass` for **Key Vault**. Syncs KV secret `cromwell-storage-sas` into a k8s Secret `cromwell-sas`.
- `openshift/cromwell-deploy-azure-wi.yaml` — Cromwell Deployment reading `STORAGE_SAS` from k8s Secret (sourced from Key Vault via CSI). Uses `cromwell-sa` with Workload Identity.
- `openshift/tes-deploy.yaml` — **TES server** Deployment/Service (placeholders). TES uses Workload Identity and calls Batch/Storage with AAD.
- `scripts/install-azure-workload-identity.sh` — Installs **azure-workload-identity** webhook and **Secrets Store CSI driver + Azure provider** on OpenShift (Helm).
- `scripts/rotate-sas-to-kv.sh` — Generates a new **SAS** using MI and **updates Key Vault** secret `cromwell-storage-sas`.
- `scripts/create-kv-secrets.sh` — One-time initializer to create `cromwell-storage-sas` in Key Vault.

### How to enable Workload Identity + Key Vault CSI on ARO

```bash
# 1) Install controllers (run as cluster-admin on ARO)
bash scripts/install-azure-workload-identity.sh

# 2) Create/Update UAMI federated identity for cromwell-sa
az deployment group create -g GenomicsRG -f iac/workload-identity.bicep \
  -p uamiId=$(az identity show -g GenomicsRG -n uami-cromwell --query id -o tsv) \
  -p oidcIssuer=<your-aro-oidc-issuer-url> \
  -p serviceAccountNamespace=genomics \
  -p serviceAccountName=cromwell-sa

# 3) Create KV secret (initial) or rotate via MI
bash scripts/create-kv-secrets.sh GenomicsKeyVault cromwell-storage-sas "<sas-value>"
# or rotate with MI:
bash scripts/rotate-sas-to-kv.sh GenomicsKeyVault cromwell-storage-sas GenomicsRG <storage-account> cromwell

# 4) Apply SA + SecretProviderClass + Deployment
oc apply -f openshift/azure-workload-identity.yaml
oc apply -f openshift/secretproviderclass-kv-cromwell-sas.yaml
oc apply -f openshift/cromwell-configmap.yaml
oc apply -f openshift/cromwell-deploy-azure-wi.yaml
```

### Batch Private Endpoint

```bash
# Discover groupIds for your Batch account
az network private-link-resource list --id $(az batch account show -g GenomicsRG -n <batch> --query id -o tsv) -o table

# Deploy PE + Private DNS
az deployment group create -g GenomicsRG -f iac/private-endpoint-batch.bicep \
  -p vnetName=GenomicsVNet subnetName=BatchSubnet \
  -p batchAccountId=$(az batch account show -g GenomicsRG -n <batch> --query id -o tsv) \
  -p groupId=<value-from-previous-command>
```

### TES notes

- Update `openshift/tes-deploy.yaml` image to a valid TES image (e.g., `ghcr.io/microsoft/tes:<tag>`).
- Create a federated identity for `tes/tes-sa` using `iac/workload-identity.bicep` (change namespace/name).
- Point Cromwell to TES endpoint (GA4GH TES) for MI-native execution on Batch.

