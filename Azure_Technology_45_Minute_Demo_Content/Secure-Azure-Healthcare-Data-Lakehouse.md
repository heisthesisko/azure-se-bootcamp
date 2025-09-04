# Secure Azure Data Lakehouse for Healthcare (Hybrid Cloud Deployment)

> **Audience:** IT Engineers in a healthcare provider (Intermediate to Expert)  
> **Goal:** Deploy a secure, compliant Data Lakehouse on Azure using Azure Data Lake Storage, Azure Synapse Analytics, Microsoft Purview, and Azure Key Vault – supporting hybrid data from on‑premises Linux/Windows servers and OpenShift containers with full HIPAA/HITRUST alignment for ePHI.

---

## Slide 1 — Why this matters to providers

>[!TIP]  
>Healthcare data (EHR records, HL7/FHIR feeds, **PACS/DICOM** imaging, genomics, etc.) is growing exponentially and retained for years. Legacy on‑prem data warehouses and NAS storage bottleneck analytics and AI on this data. An **Azure Data Lakehouse** provides cloud-scale storage and compute, enabling unified analysis of multi-modal health data with robust security and disaster recovery.

>[!TIP]  
>**Pro:** Unify **structured** (EHR, claims) and **unstructured** (imaging, notes) data on one platform; scale compute on-demand for population health analytics and AI.  
>**Con:** Hybrid success depends on reliable **ExpressRoute/VPN** connectivity and disciplined **data governance** to protect PHI.

---

## Slide 2 — Terminology & scope

- **Azure Data Lake Storage Gen2 (ADLS):** Scalable object storage with hierarchical namespaces for big data analytics (foundation of the data lake). Stores raw and curated healthcare data, with POSIX-style ACLs and data encryption at rest.
- **Azure Synapse Analytics:** Unified analytics platform (Spark, SQL, pipelines) to process and query lakehouse data. Provides Spark pools for big data processing and SQL pools (serverless or dedicated) for warehousing on the data lake.
- **Microsoft Purview:** Unified data governance service for discovery, cataloging, classification of sensitive data (PHI/PII), and end-to-end data lineage tracking across data estate.
- **Azure Key Vault:** Secure vault for encryption keys (CMKs) and secrets. Used to manage keys for ADLS and Synapse encryption (customer-managed keys) and certificates (TLS) to meet compliance.
- **Hybrid connectivity:** Private networking (ExpressRoute or VPN) connecting on-premises environments to Azure. Ensures data transfer between on-prem systems and Azure is secure and low-latency.
- **OpenShift (ARO/OCP):** Red Hat OpenShift Container Platform (on-prem or Azure Red Hat OpenShift) hosting containerized apps (e.g. microservices, streaming ingestion) that integrate with the Azure data lakehouse via secure network and APIs.
- **Compliance focus:** Architected for **HIPAA** (under BAA), **HITRUST** CSF controls, and data standards like **FHIR** (clinical data) and **DICOM** (imaging), ensuring protection of **ePHI** throughout.

---

## Slide 3 — Compliance lens (HIPAA, HITRUST, FHIR/DICOM)

- **HIPAA eligibility & BAA:** Use only Azure services covered by Microsoft’s HIPAA Business Associate Agreement. Configure safeguards per the HIPAA Security Rule (access control, audit logs, encryption, breach reporting).
- **HITRUST alignment:** Inherit Azure platform controls (many services certified/assessed). Implement customer responsibilities: strict identity management, network isolation, logging, backup, and incident response.
- **Azure Policy – HIPAA/HITRUST:** Assign the built‑in HIPAA/HITRUST compliance initiative to relevant resource groups. This continuously audits configurations, flagging non-compliant resources (e.g., unencrypted storage, open firewall). Use the Policy compliance dashboard as evidence for auditors.
- **FHIR & DICOM considerations:** Store FHIR JSON/HL7 messages and DICOM files in a compliant manner. Restrict access by role; implement lifecycle for large DICOM datasets (retention rules, archive tier) to meet regulatory retention.
- **Shared responsibility:** Azure provides secure foundation; you configure application-level security (identity, access, network, and data handling). Document responsibilities for audits.

>[!TIP]  
>Leverage **Azure Policy Regulatory Compliance** tracking for HIPAA/HITRUST to monitor posture continuously. It maps Azure configurations to HIPAA safeguards and HITRUST controls, providing audit-ready evidence.

---

## Slide 4 — Reference architecture (Hybrid on‑premises to Azure)

```mermaid
flowchart LR
  subgraph Edge["On-prem Clinics & Home | Linux + OpenShift"]
    G1["Glucose Monitor"]:::dev --> GW["Linux Edge Gateway<br/>IoT Edge MQTT/AMQP"];
    H1["Heart-rate Sensor"]:::dev --> GW;
    V1["Vitals (BP SpO2)"]:::dev --> GW;
    GW -->| "MQTT 3.1.1 TLS1.2 8883" | BR["Edge MQTT Broker<br/>IoT Edge"];
  end

  BR -->| "Upstream MQTT/AMQP TLS" | IOTHUB{{"Azure IoT Hub"}};
  IOTHUB -- "Routes" --> ASA[["Azure Stream Analytics"]];
  ASA -- "Output" --> FN[("Azure Functions<br/>Python on Linux")];
  FN --> FHIR[("Azure Health Data Services<br/>FHIR Service R4")];

  classDef dev fill:#eef,stroke:#447;

```

**Notes:** On-premises connects to Azure over private secure network (ExpressRoute or site-to-site VPN). Data Lake (ADLS) and Synapse use **Private Endpoints**; Key Vault holds CMKs; Purview scans/catalogs ADLS and Synapse. All in **US regions**.

---

## Slide 5 — Lakehouse architecture & features

- **Medallion architecture (Bronze/Silver/Gold):** Bronze (raw) zone ingests source data (EHR extracts, HL7/FHIR, device telemetry). Silver (enriched) cleanses/standardizes. Gold (curated) stores analytics-ready datasets.
- **Multi-modal support:** Store **structured** (CSV, Parquet), **semi-structured** (JSON/HL7), and **unstructured** (DICOM, PDFs) in one repository.
- **Delta Lake:** Use **Delta** in Silver/Gold for ACID, schema enforcement, time travel, and safe upserts/deletes.
- **Synapse unified analytics:** Spark for ETL/ML; Serverless/Dedicated SQL for BI; both directly on ADLS to avoid copies.
- **Open standards:** Parquet/CSV/Delta; access via ABFS/HTTPS for interoperability with on-prem and multi-cloud tools.

**Caveats:** Plan naming, partitioning, and folder taxonomy per compliance and performance needs. Re-platform some legacy ETL (e.g., SSIS → Synapse pipelines/Spark).

---

## Slide 6 — Performance & scalability benefits

- **Decoupled storage/compute:** Independently scale ADLS and Synapse; eliminate fixed on-prem capacity ceilings.
- **Cloud-scale throughput:** Parallel ingest/compute for DICOM studies, HL7 feeds, genomics pipelines.
- **Low latency in-region:** Synapse in same region as ADLS; run compute near the data.
- **Elastic burst:** Scale Spark/SQL pools up for peak loads; scale down off-hours.
- **Optimized tiers:** Hot/Cool/Archive with lifecycle rules to balance cost/perf.

---

## Slide 7 — Protecting ePHI: security at rest & in transit

- **At rest:** Storage encryption by default; enable **CMKs** in Key Vault for ADLS and Synapse; rotate keys.
- **In transit:** Enforce **TLS 1.2+**; use SFTP/HTTPS for ingestion; private ER/VPN transport.
- **Network isolation:** **Private Endpoints** for Storage, Synapse, Key Vault; NSGs/Azure Firewall to restrict subnets/ports.
- **Access control:** Azure AD auth; **RBAC** on resources; ADLS POSIX ACLs for folders/files; Synapse **RLS/CLS** and dynamic masking.
- **Monitoring:** Azure Monitor, Activity Logs, Synapse audit, Defender for Storage; SIEM alerts; avoid PHI in logs.

---

## Slide 8 — Compliance mapping quick reference

| Regulation / Standard                     | Key Requirement                  | Azure Implementation                                     | Notes for Lakehouse                                      |
|-------------------------------------------|----------------------------------|----------------------------------------------------------|----------------------------------------------------------|
| **HIPAA 164.312(a)(1) Access Control**    | Unique user ID & controlled access | Azure AD auth; RBAC; Synapse RLS/CLS                     | Least privilege, MFA, periodic access reviews            |
| **HIPAA 164.312(c)(1) Data Integrity**    | Prevent improper alteration       | ADLS versioning/soft delete; Delta ACID; backups         | Immutable (WORM) for raw if required; audit trails       |
| **HIPAA 164.312(e)(1) Transmission**      | Encrypt in transit                | TLS 1.2+; ER private peering; IPsec as needed            | No plaintext PHI traffic                                 |
| **HITRUST CSF (Monitoring)**              | Continuous monitoring & audit     | Azure Monitor/Policy; Defender; Sentinel                 | Alerts on policy violations and anomalies                |
| **FHIR & DICOM Standards**                | Interoperable formats & retention | Store FHIR/DICOM; tiering for large objects              | Retention policies; archive to Cool/Archive              |
| **Business Associate Agreement (BAA)**    | Contractual HIPAA compliance      | Use HIPAA-eligible services under BAA                    | Enforce secure configs via Policy/Blueprints             |

>[!TIP]  
>Apply **Resource Locks** to critical resources (Storage, Key Vault) to prevent accidental deletion/changes.

---

## Slide 9 — Business Continuity & Disaster Recovery (BCDR)

- **Geo redundancy:** Use **RA-GRS** for ADLS to maintain secondary copy in a paired US region; plan failover.
- **Object replication:** Container-level replication between storage accounts for controlled RPO/RTO.
- **Synapse DR:** Git source control for notebooks/pipelines; redeploy workspace via IaC; restore dedicated pools from geo-backups.
- **Purview DR:** Plan metadata export/secondary deployment strategy; include governance in DR runbooks.
- **Backup/restore:** Enable soft delete & versioning; test restores; consider offline backups for critical datasets.
- **HA patterns:** Triple replication in-region; Spark checkpointing/resume; Key Vault redundancy.
- **DR drills:** Test regional failover (storage + Synapse) and validate RTO/RPO; document runbooks.
- **On-prem continuity:** Queue ingestion locally when links fail; use Stack Edge/Data Box Gateway for buffering.

---

## Slide 10 — Real-time analytics and AI readiness

- **Streaming ingestion:** Event Hubs/IoT Hub to Bronze; capture to ADLS; process via Synapse Spark or ASA.
- **Autoloader/Delta streaming:** Continuous ETL with exactly-once semantics.
- **Synapse Link/Change feed:** Near-real-time replication from operational stores for HTAP scenarios.
- **AI/ML:** Train models on curated Gold data with Synapse Spark or Azure ML; GPU pools; store models in ADLS.
- **Power BI:** Connect to serverless SQL or Delta tables; DirectLake patterns for large datasets.
- **Workload isolation:** Separate Spark/SQL pools per team; avoid contention; quota and cost controls.

---

## Slide 11 — Hybrid integration with on‑premises & OpenShift

- **Connectivity:** **ExpressRoute or VPN** for private, low-latency links; plan bandwidth for imaging and batch loads.
- **On-prem ingestion:** Self‑Hosted Integration Runtime (ADF/Synapse) for DB pulls; **AzCopy**/CLI/SFTP for files (SFTP on Storage).
- **OpenShift access:** Use Azure SDKs/REST (ABFS) from containers; store secrets in K8s Secrets/Key Vault; use managed identity on ARO.
- **Virtualization:** Synapse pipelines/Spark can query on‑prem sources via private link; on‑prem BI tools can query Synapse securely.
- **Identity:** Sync AD to AAD; use AAD auth for ADLS/Synapse; optional AAD Kerberos for Hadoop ecosystems.
- **ARO in Azure:** Place ARO in same VNet; use NetworkPolicies; integrate AAD SSO; Kafka bridge patterns for buffered transfer.
- **Edge:** Stack Edge/IoT Edge for intermittent sites; eventual sync to central lake.
- **Governance:** Purview scans on-prem databases via integration runtime; unified catalog across estate.

---

## Slide 12 — Data governance with Microsoft Purview

- **Catalog:** Scan **ADLS** (Bronze/Silver/Gold) and **Synapse**; register assets and schemas in a central catalog.
- **Classification:** Auto-detect PHI/PII (e.g., SSN, names, DOB); add custom classifiers for MRN formats.
- **Lineage:** Capture pipeline lineage (Bronze → Silver → Gold); use for impact analysis and audits.
- **Glossary:** Define healthcare terms (Encounter, Readmission) and link to assets; improve data literacy.
- **Access:** RBAC in Purview; restrict who sees sensitive classifications.
- **Compliance:** Export catalog/classification reports for auditors; integrate with Compliance Manager.
- **Scheduling:** Run periodic scans (daily/weekly) to capture new data; include dev/test environments.
- **Policy (emerging):** Keep track of Purview data access policy features for ABAC centralization.

---

## Slide 13 — Anticipated objections & responses

- **Security of PHI in cloud:** Azure offers encryption, private networking, continuous monitoring, and HIPAA BAA; well-architected Azure is often more secure than legacy stacks.
- **“We already have on‑prem analytics”**: Lakehouse handles volume/variety beyond legacy limits; integrates imaging/genomics; elastic scale; faster time-to-insight.
- **Latency/performance:** Run compute in-region near data; cache curated results; ER bandwidth; hybrid caches for edge cases.
- **Skills/complexity:** Synapse unifies SQL + Spark; low-code pipelines; training & pilot projects help upskill.
- **Cost/governance:** Cost budgets/alerts; storage tiering; Policy + Purview enforce guardrails; tagging/chargeback.

---

## Slide 14 — Demo 1: Deploy core Lakehouse infrastructure (Azure CLI)

> Run in **Azure Cloud Shell** (Bash).

```bash
# Set variables
RESOURCE_GROUP="<YourResourceGroup>"
LOCATION="eastus"  # US region
STORAGE_ACCT="<adlstoName>"  # globally unique
SYNAPSE_WS="<synapseWsName>"
PURVIEW_ACCT="<purviewName>"  # unique
KEYVAULT="<keyVaultName>"

# 1. RG & VNet
az group create -n $RESOURCE_GROUP -l $LOCATION
az network vnet create -g $RESOURCE_GROUP -n dataVNet -l $LOCATION --address-prefixes 10.10.0.0/16
az network vnet subnet create -g $RESOURCE_GROUP --vnet-name dataVNet -n privatesubnet --address-prefixes 10.10.1.0/24

# 2. Key Vault + CMK
az keyvault create -g $RESOURCE_GROUP -n $KEYVAULT -l $LOCATION --sku Standard --enable-soft-delete true --enable-purge-protection true 
az keyvault key create --vault-name $KEYVAULT -n "datalake-cmk" -p software

# 3. ADLS Gen2 with CMK + secure network
az storage account create -g $RESOURCE_GROUP -n $STORAGE_ACCT -l $LOCATION   --kind StorageV2 --sku Standard_RAGRS --enable-hierarchical-namespace true   --encryption-key-source Microsoft.Keyvault   --encryption-key-name "datalake-cmk"   --encryption-key-vault-key-uri $(az keyvault key show --vault-name $KEYVAULT -n "datalake-cmk" --query key.kid -o tsv)   --allow-blob-public-access false --min-tls-version TLS1_2 --default-action Deny
```

---

## Slide 15 — Demo 2: Deploy Synapse & Purview, configure networking

```bash
# 4. Synapse workspace (managed VNet) with lake attached and CMK
az synapse workspace create -g $RESOURCE_GROUP -n $SYNAPSE_WS -l $LOCATION   --storage-account $STORAGE_ACCT --file-system "synapsefs"   --sql-admin-login-user "sqladminuser" --sql-admin-login-password "Str0ngP@ssw0rd!"   --enable-managed-vnet true --key-name "datalake-cmk" --key-vault-url https://$KEYVAULT.vault.azure.net/

# 5. Purview account
az extension add --name purview || true
az purview account create -g $RESOURCE_GROUP -n $PURVIEW_ACCT -l $LOCATION --sku Standard

# 6. Storage network rules (deny by default; allow VNet)
az storage account update -g $RESOURCE_GROUP -n $STORAGE_ACCT --default-action Deny --bypass AzureServices
az storage account network-rule add -g $RESOURCE_GROUP -n $STORAGE_ACCT --subnet dataVNet/privatesubnet

# 7. (Optional) Private Endpoints (Blob/DFS, Synapse dev/SQL, Key Vault)
# Example for Blob; repeat for dfs, Synapse endpoints, and Key Vault
az network private-endpoint create -g $RESOURCE_GROUP -n pe-adls --vnet-name dataVNet --subnet privatesubnet   --private-connection-resource-id $(az storage account show -g $RESOURCE_GROUP -n $STORAGE_ACCT --query id -o tsv)   --group-id blob --connection-name adls-privconn
```

---

## Slide 16 — Demo 3: Security hardening (RBAC, Policy, Defender)

```bash
# 8. RBAC for Synapse MI and Purview MI on Storage
SYNAPSE_MI_OBJECTID=$(az synapse workspace show -g $RESOURCE_GROUP -n $SYNAPSE_WS --query "identity.principalId" -o tsv)
STG_ID=$(az storage account show -g $RESOURCE_GROUP -n $STORAGE_ACCT --query id -o tsv)
az role assignment create --assignee-object-id $SYNAPSE_MI_OBJECTID --assignee-principal-type ServicePrincipal   --role "Storage Blob Data Contributor" --scope $STG_ID

PURVIEW_MI_OBJECTID=$(az purview account show -g $RESOURCE_GROUP -n $PURVIEW_ACCT --query "identity.principalId" -o tsv)
az role assignment create --assignee-object-id $PURVIEW_MI_OBJECTID --assignee-principal-type ServicePrincipal   --role "Storage Blob Data Reader" --scope $STG_ID

# 9. Azure Policy: HIPAA/HITRUST initiative
POLICY_INITIATIVE_ID=$(az policy set-definition list --query "[?contains(displayName, 'HIPAA') && contains(displayName, 'HITRUST')].name" -o tsv | head -n1)
az policy assignment create -n "HIPAA-HITRUST-Compliance" -g $RESOURCE_GROUP --policy-set-definition $POLICY_INITIATIVE_ID

# 10. Microsoft Defender for Storage
az security pricing create --name "StorageAccounts" --tier "Standard"
```

---

## Slide 17 — Demo 4: Ingest sample data & Purview classification

```bash
# Create containers and upload sample assets
az storage container create --account-name $STORAGE_ACCT -n bronze
az storage container create --account-name $STORAGE_ACCT -n silver
az storage container create --account-name $STORAGE_ACCT -n gold

# Upload a sample CSV (replace with your local path or use Azure Storage Explorer)
az storage blob upload --account-name $STORAGE_ACCT -c bronze -f AdmissionsQ3.csv -n hospitalA/admissions/AdmissionsQ3.csv
# Upload a sample DICOM
az storage blob upload --account-name $STORAGE_ACCT -c bronze -f ChestXray001.dcm -n hospitalA/dicom/ChestXray001.dcm
```

- Register ADLS and Synapse as data sources in **Purview Studio**.  
- Run a **scan** on ADLS Bronze container; review **classifications** (PII/PHI) and **lineage** for pipelines.

---

## Slide 18 — Demo 5: Analytics in Synapse (SQL & Spark)

**Serverless SQL (ad-hoc):**
```sql
SELECT TOP 10 
    PatientName, Diagnosis, CONVERT(date, AdmissionDate, 101) AS AdmissionDate 
FROM OPENROWSET(
    BULK 'https://<storage-account>.dfs.core.windows.net/bronze/hospitalA/admissions/AdmissionsQ3.csv',
    FORMAT = 'CSV', PARSER_VERSION = '2.0', FIRSTROW = 2
) WITH (
    PatientName VARCHAR(100),
    SSN VARCHAR(12),
    Diagnosis VARCHAR(100),
    AdmissionDate VARCHAR(20)
) AS adm
WHERE Diagnosis LIKE '%Pneumonia%';
```

**Spark ETL to Delta (Silver):**
```python
from pyspark.sql.functions import col
df = spark.read.csv("abfss://bronze@<storage-account>.dfs.core.windows.net/hospitalA/admissions/", header=True, inferSchema=True)
df_filtered = df.filter(col("Diagnosis").isNotNull())
df_filtered.write.format("delta").mode("overwrite").save("abfss://silver@<storage-account>.dfs.core.windows.net/hospitalA/admissions_delta")
spark.sql("CREATE TABLE IF NOT EXISTS SilverAdmissions USING delta LOCATION 'abfss://silver@<storage-account>.dfs.core.windows.net/hospitalA/admissions_delta'")
spark.sql("SELECT Diagnosis, COUNT(*) as Cnt FROM SilverAdmissions GROUP BY Diagnosis ORDER BY Cnt DESC LIMIT 10").show()
```

---

## Slide 19 — Governance & operations

- **IaC:** Convert CLI to **Bicep** for repeatable deployments; use CI/CD.
- **RBAC & PIM:** Just‑in‑time admin; least-privilege roles.
- **Policy guardrails:** Enforce tagging, allowed regions (US), encryption, private endpoints.
- **SOPs:** Snapshot/backup standards; access review cadence; incident response playbooks.
- **Monitoring:** Dashboards for capacity/throughput; alerts for anomalies and policy violations.

---

## Slide 20 — Quick wins checklist (hospital ready)

- ✅ ADLS with **hierarchical namespace**, CMK encryption, private endpoints  
- ✅ Synapse with **managed VNet**, RBAC, audit logs  
- ✅ Purview scans with **PHI/PII classifications** and lineage  
- ✅ **HIPAA/HITRUST** policy assignment and Defender for Storage  
- ✅ Bronze/Silver/Gold structure with **Delta** in curated zones  
- ✅ DR plan: **RA-GRS**, object replication, Synapse redeploy + Git

---

## Slide 21 — Reference Bicep (Storage + Key Vault + Synapse skeleton)

```bicep
param location string = 'eastus'
param storageAccountName string
param keyVaultName string
param synapseName string
param cmkName string = 'datalake-cmk'
param fileSystem string = 'synapsefs'

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: { family: 'A', name: 'standard' }
    enablePurgeProtection: true
    enableSoftDelete: true
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
  }
}

resource key 'Microsoft.KeyVault/vaults/keys@2023-02-01' = {
  name: '${keyVaultName}/${cmkName}'
  properties: { kty: 'RSA' }
}

resource stg 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: { name: 'Standard_RAGRS' }
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    encryption: {
      keySource: 'Microsoft.Keyvault'
      keyVaultProperties: {
        keyName: cmkName
        keyVaultUri: kv.properties.vaultUri
      }
      services: {
        blob: { enabled: true }
      }
    }
    isHnsEnabled: true
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
  }
}

resource syn 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: synapseName
  location: location
  properties: {
    defaultDataLakeStorage: {
      accountUrl: 'https://${storageAccountName}.dfs.core.windows.net'
      filesystem: fileSystem
    }
    managedVirtualNetwork: 'default'
    encryption: {
      cmk: {
        key: {
          name: cmkName
          keyVaultUrl: kv.properties.vaultUri
        }
      }
    }
  }
}
```

---

## Slide 22 — Takeaways & next steps

- **Hybrid, secure analytics:** A modern lakehouse supports PHI safely with CMKs, private endpoints, and strong RBAC.
- **Governed and auditable:** Purview gives catalog, classification, and lineage to satisfy audits and enable trust.
- **Elastic performance:** Scale compute as needed; use Delta for reliability; optimize costs with tiers.
- **Action plan:** Pilot a focused use case; codify deployment with Bicep; schedule Purview scans; establish DR drills.

---

### Appendix — Operations runbook snippets

```bash
# Check storage encryption and network
az storage account show -g $RESOURCE_GROUP -n $STORAGE_ACCT --query "{hns:enableHierarchicalNamespace, enc:encryption.keySource, network:networkRuleSet.defaultAction}"

# Synapse workspace identity and roles
az synapse workspace show -g $RESOURCE_GROUP -n $SYNAPSE_WS --query identity
az role assignment list --assignee $SYNAPSE_MI_OBJECTID -o table

# Purview data map assets
az purview account show --name $PURVIEW_ACCT -g $RESOURCE_GROUP
```

