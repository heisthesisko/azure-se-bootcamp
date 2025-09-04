---
title: "Real-Time Remote Patient Monitoring on Azure (IoT Hub + Stream Analytics + Functions)"
subtitle: "Secure ingest & processing of medical device telemetry with HIPAA / FHIR / DICOM / HITRUST controls"
author: "PhD CS Engineer · Azure Architect"
date: "2025-09-04"
audience: "Healthcare IT Engineers (Intermediate→Expert)"
duration: "45 minutes"
---

> **Context**: Integrates with on‑prem **EPIC** EHR; ingests **glucose monitors**, **heart‑rate sensors**, and **general vitals via MQTT**. Focused on **Linux** and **OpenShift** for hybrid. Includes placeholders for **AI early‑warning/triage**.

---

## 0. Agenda (45 min)

1. **Architecture** (8) — dataflow, hybrid topologies, EPIC integration
2. **Security & Compliance** (10) — HIPAA/HITRUST, FHIR, DICOM, ePHI protections
3. **Deployment (CLI/Bicep)** (10) — automated build of core PaaS + network isolation
4. **Stream Processing & FHIR Mapping** (7) — ASA query + Functions → FHIR R4
5. **Operations, BCDR & Performance** (6) — monitoring, DR, tuning
6. **Objections & Q&A** (4)

> Modeled after your previous healthcare deck structure (slide-based markdown, CLI-first, prescriptive notes). fileciteturn4file0

---

## 1. Reference Architecture (hybrid, Linux/OpenShift)

```mermaid
flowchart LR
  subgraph Edge["On‑prem Clinics & Home | Linux + OpenShift"]
    G1[Glucose Monitor]:::dev --> GW[Linux Edge Gateway<br/>IoT Edge MQTT/AMQP]
    H1[Heart-rate Sensor]:::dev --> GW
    V1[Vitals (BP/SpO2)]:::dev --> GW
    GW -->|MQTT 3.1.1 TLS1.2 8883| BR[Edge MQTT Broker / IoT Edge]
    BR -->|DPS attestation (X.509)| GW
  end

  BR -->|Upstream MQTT/AMQP TLS| IOTHUB{{Azure IoT Hub}}
  IOTHUB -- Routes --> ASA[[Azure Stream Analytics]]
  ASA -- Output --> FN[(Azure Functions<br/>Python on Linux)]
  FN --> FHIR[(Azure Health Data Services<br/>FHIR Service R4)]
  FN -. optional .-> AI[(AI Early Warning<br/>(Anomaly/Sepsis risk))]
  FHIR -->|FHIR R4 REST| EPIC[(EPIC EHR<br/>(FHIR/HL7v2/Bridges))]

  subgraph Sec["Security Boundary (Azure VNet)"]
    IOTHUB -. Private Endpoint .- VNET[(VNet + Private DNS)]
    ASA -. DIAG .- LA[(Log Analytics)]
    FN -. VNet Integration .- VNET
    FHIR -. Private Endpoint .- VNET
    KV[(Key Vault/HSM)] -. CMK .- FHIR
    DEF[(Defender for IoT)] -. Telemetry .- LA
  end

classDef dev fill:#eef,stroke:#447;
```
**Notes:** MQTT to IoT Hub must use **TLS 1.2**; IoT Hub supports **MQTT 3.1.1 on 8883** or **MQTT over WebSockets on 443**; use **X.509** device auth with **DPS** for zero‑touch provisioning. citeturn2search0turn0search0turn0search10

---

## 2. Trust Boundaries & Network Isolation

- **Private Endpoints** for **IoT Hub** (ingress), **FHIR** service, and (optionally) **Log Analytics** cluster (CMK). Use **Private DNS** zones and disable public network access where feasible. citeturn9search5turn1search8
- **API Management (APIM)** optionally fronts FHIR, with **inbound private endpoint** and **VNet integration** for controlled egress to EPIC interfaces. citeturn4search2turn4search0
- **Functions (Linux)** use **VNet integration** for **outbound** private calls to FHIR/APIM; inbound Function is HTTP‑triggered only by **ASA output**. citeturn4search10

**CLI tip (discover groupIds for Private Endpoints):**
```bash
az network private-link-resource list   --name $IOTHUB_NAME --type Microsoft.Devices/IotHubs -g $RG -o table
# Use the returned groupId with az network private-endpoint create --group-ids <id>
``` 
citeturn12search0

---

## 3. Data Standards & Interop

- **FHIR R4** target for vitals → *Observation* resources; include LOINC codes e.g., **Heart Rate 8867-4**, **Glucose 2339-0**.
- **Azure Health Data Services (AHDS)** provides managed **FHIR**, **DICOM**, and **MedTech** services; **FHIR** supports CMK and Private Link. citeturn0search3turn8search1turn1search2
- **MedTech service** can normalize device payloads and map to FHIR Observations with visual **Mapping debugger** (optional alternative to our custom Function). citeturn4search1turn4search3turn4search5
- **DICOM** (imaging) not central to RPM vitals, but AHDS **DICOM service** is available if integrating waveform images or echo snapshots. citeturn5search0

---

## 4. Security Controls for ePHI (Defense-in-Depth)

- **Transport**: Enforce **TLS 1.2** for MQTT to IoT Hub; prefer **X.509 CA‑signed** device auth (HSM on device). citeturn2search0turn2search9
- **Identity**: Backend uses **Managed Identity**/**Microsoft Entra** for FHIR calls; Function requests tokens for audience `https://<fhir>.azurehealthcareapis.com`. citeturn11search1
- **Network**: **Private Link** + **Private DNS** for IoT Hub, FHIR, APIM; optionally allow **trusted Microsoft services** at IoT Hub egress. citeturn9search5
- **Encryption-at-rest**: 
  - AHDS **FHIR**/**DICOM** support **CMK** via **Key Vault/HSM**. citeturn8search1
  - Stream Analytics persists **private assets** in your Storage (use **CMK**). citeturn6search1
  - IoT Hub data is encrypted with service‑managed keys by default; CMK support appears in **preview policies**—validate availability for your regions/tiers before use. citeturn7search1turn7search4
- **Monitoring & Threat Protection**: Enable **Microsoft Defender for IoT** on the hub → alerts into **Log Analytics**/**Sentinel**. citeturn3search3
- **Diagnostics**: Route IoT Hub metrics/logs to **Log Analytics** with diagnostic settings; consider **CMK** for **Log Analytics dedicated clusters**. citeturn5search1turn7search7
- **Compliance program**: Assign **Azure Policy** regulatory initiative **HIPAA/HITRUST** at subscription/management group; remediate drifts continuously. citeturn3search0

> **HIPAA & BAA**: Azure provides HIPAA‑eligible services under a Business Associate Agreement; you must configure them securely and operate within shared responsibility. citeturn0search18

---

## 5. RPM Pipeline — Stream Analytics + Functions → FHIR

```mermaid
flowchart TD
  subgraph Ingest
    D1>Device MQTT] -- TLS1.2 --> I[IoT Hub]
  end
  I -- Route: vitals --> A[Stream Analytics Job]
  A -- Output 1 --> F[Azure Function (HTTP trigger)]
  A -- Output 2 (optional) --> S[Storage / ADX]
  F -- POST /Observation --> R[(FHIR Service)]
```
- **ASA → Function output** lets you run code for enrichment, validation, and calls to FHIR with managed identity. citeturn0search2turn0search7

**Example ASA Query (thresholds + windowed smoothing):**
```sql
WITH Base AS (
  SELECT
    deviceId,
    CAST(System.Timestamp AS datetime) AS enqueuedTime,
    TRY_CAST(GetRecordPropertyValue([telemetry], 'hr') AS bigint) AS hr,
    TRY_CAST(GetRecordPropertyValue([telemetry], 'glucose') AS float) AS glucose_mgdl,
    TRY_CAST(GetRecordPropertyValue([telemetry], 'spo2') AS float) AS spo2,
    TRY_CAST(GetRecordPropertyValue([telemetry], 'bp_sys') AS int) AS bp_sys,
    TRY_CAST(GetRecordPropertyValue([telemetry], 'bp_dia') AS int) AS bp_dia
  FROM iothubinput TIMESTAMP BY enqueuedtime
)
, Smoothed AS (
  SELECT
    deviceId,
    AVG(hr) OVER (PARTITION BY deviceId LIMIT DURATION(minute, 1)) AS hr_avg1m,
    AVG(glucose_mgdl) OVER (PARTITION BY deviceId LIMIT DURATION(minute, 5)) AS glu_avg5m,
    System.Timestamp AS ts
  FROM Base TIMESTAMP BY enqueuedTime
)
SELECT
  deviceId, hr_avg1m, glu_avg5m, ts,
  CASE WHEN hr_avg1m > 120 OR hr_avg1m < 40 THEN 1 ELSE 0 END AS hr_alert,
  CASE WHEN glu_avg5m > 300 OR glu_avg5m < 60 THEN 1 ELSE 0 END AS glu_alert
INTO functionoutput
FROM Smoothed;
```

---

## 6. EPIC Integration (FHIR/HL7v2)

- **Direct FHIR (R4)**: Push Observations to AHDS FHIR; EPIC consumes via **FHIR R4 endpoints** (site‑specific behavior differences require testing per customer). citeturn1search1turn1search9
- **HL7v2 via Interface Engine** (e.g., Bridges/Cloverleaf/Mirth): Map Observations to ORU^R01; expose via APIM privately.

---

## 7. Deployment — Prereqs (US Regions)

- Enterprise agreement with **BAA** in place; choose paired US regions.
- **Resource naming**: `rg-rpm-<env>-<region>`, `ioth-<env>`, `fhir-<env>`, `asa-<env>`, `func-<env>`.
- **Identity**: Create **User Assigned Managed Identity** or use **System Assigned** for Functions and ASA if needed.

---

## 8. Deployment — CLI (high level)

```bash
# 1) Variables
export SUB=00000000-0000-0000-0000-000000000000
export RG=rg-rpm-dev-eus2
export LOC=eastus2
export IOTHUB_NAME=ioth-rpm-dev-eus2
export DPS_NAME=dps-rpm-dev-eus2
export LA_NAME=log-rpm-dev-eus2
export SA_NAME=strpm${RANDOM}
export VNET=vnet-rpm-dev
export SUBNET_PRIV=sn-pe
export KV_NAME=kv-rpm-dev-${RANDOM}
export FHIR_WS=ws-rpm-dev
export FHIR_SVC=fhir-rpm-dev
export FUNC_NAME=func-rpm-dev-eus2
export APIM_NAME=apim-rpm-dev
az account set -s $SUB

# 2) Resource group and network
az group create -n $RG -l $LOC
az network vnet create -g $RG -n $VNET --address-prefixes 10.40.0.0/16   --subnet-name $SUBNET_PRIV --subnet-prefixes 10.40.0.0/24

# 3) Deploy core infra via Bicep (see infra/bicep/main.bicep)
az deployment group create -g $RG -f infra/bicep/main.bicep   -p location=$LOC iotHubName=$IOTHUB_NAME laName=$LA_NAME   storageAccountName=$SA_NAME keyVaultName=$KV_NAME   fhirWorkspaceName=$FHIR_WS fhirServiceName=$FHIR_SVC funcAppName=$FUNC_NAME

# 4) Create IoT Hub device identity for simulator (X.509 or SAS for demo)
az iot hub device-identity create -n $IOTHUB_NAME -d demo-device --am x509_thumbprint   --primary-thumbprint <DEVICE_CERT_THUMBPRINT>

# 5) Private endpoints (discover group IDs first)
IOTHUB_ID=$(az iot hub show -n $IOTHUB_NAME --query id -o tsv)
az network private-link-resource list --id $IOTHUB_ID -o table
# Use returned groupId, for example 'iotHub'
az network private-endpoint create -g $RG -n pe-iothub --vnet-name $VNET --subnet $SUBNET_PRIV   --private-connection-resource-id $IOTHUB_ID --group-ids iotHub --connection-name peconn-iothub
# Repeat for FHIR service and (optionally) Log Analytics cluster
```

> The Bicep template provisions ASA job, Function App (Linux), FHIR service, and ties diagnostics to Log Analytics with RBAC least privilege. See `/infra/bicep/main.bicep`.

---

## 9. Function (Python on Linux) — FHIR mapping

- HTTP‑triggered by **ASA output** with managed identity auth to FHIR:
```python
# functions/triage_function/__init__.py (excerpt)
from azure.identity import DefaultAzureCredential
import requests, os, json, datetime

FHIR_URL = os.environ["FHIR_URL"]                      # e.g., https://fhir-rpm-dev.azurehealthcareapis.com
CRED = DefaultAzureCredential()

def _token():
    scope = f"{FHIR_URL}/.default"
    return CRED.get_token(scope).token  # Entra ID token for FHIR audience

def build_observation(device_id, ts, code, system, display, value, unit):
    return {{
      "resourceType": "Observation",
      "status": "final",
      "category": [{{"coding": [{{"system":"http://terminology.hl7.org/CodeSystem/observation-category","code":"vital-signs"}}]}}],
      "code": {{"coding":[{{"system": system, "code": code, "display": display}}]}},
      "subject": {{"reference": f"Patient/{device_id}"}},
      "effectiveDateTime": ts,
      "valueQuantity": {{"value": value, "unit": unit, "system":"http://unitsofmeasure.org"}}
    }}

def main(req):
    evt = req.get_json()
    obs = []
    if evt.get("hr_alert"):
        obs.append(build_observation(evt["deviceId"], evt["ts"], "8867-4", "http://loinc.org", "Heart rate", evt["hr_avg1m"], "beats/min"))
    if evt.get("glu_alert"):
        obs.append(build_observation(evt["deviceId"], evt["ts"], "2339-0", "http://loinc.org", "Glucose", evt["glu_avg5m"], "mg/dL"))
    h = {{"Authorization": f"Bearer {_token()}", "Content-Type":"application/fhir+json"}}
    resps = [requests.post(f"{FHIR_URL}/Observation", headers=h, data=json.dumps(o)) for o in obs]
    return {{ "posted": [r.status_code for r in resps] }}
```
> FHIR token audience is the **service URL**; managed identity needs **FHIR Data Contributor** role. citeturn11search1

---

## 10. Device Telemetry — Linux (MQTT, TLS 1.2)

```python
# device-simulator/send_telemetry.py (excerpt)
import time, json, hmac, hashlib, base64, urllib.parse, os, ssl
import paho.mqtt.client as mqtt

IOTHUB_HOST = os.environ["IOTHUB_HOST"]  # e.g., ioth-rpm-dev-eus2.azure-devices.net
DEVICE_ID   = os.environ["DEVICE_ID"]
SHARED_KEY  = os.environ["DEVICE_KEY"]   # demo only; use X.509 in prod
USER = f"{IOTHUB_HOST}/{DEVICE_ID}/?api-version=2021-04-12"
PUB_TOPIC = f"devices/{DEVICE_ID}/messages/events/"
PORT=8883

def sas_token(uri, key, ttl=3600):
    expiry = int(time.time()) + ttl
    sign_key = "%s\n%d" % ((urllib.parse.quote(uri, safe='')), expiry)
    sig = base64.b64encode(hmac.new(base64.b64decode(key), sign_key.encode('utf-8'), hashlib.sha256).digest())
    return f"SharedAccessSignature sr={urllib.parse.quote(uri)}&sig={urllib.parse.quote(sig)}&se={expiry}"

client = mqtt.Client(client_id=DEVICE_ID, protocol=mqtt.MQTTv311)
client.username_pw_set(USER, password=sas_token(f"{IOTHUB_HOST}/devices/{DEVICE_ID}", SHARED_KEY))
client.tls_set(ca_certs=None, certfile=None, keyfile=None, cert_reqs=ssl.CERT_REQUIRED, tls_version=ssl.PROTOCOL_TLSv1_2)

client.connect(IOTHUB_HOST, PORT)
while True:
    msg = {{"telemetry":{{"hr": 78, "glucose": 110.0, "spo2": 98}}, "deviceId": DEVICE_ID}}
    client.publish(PUB_TOPIC, json.dumps(msg), qos=1)
    time.sleep(5)
```
> **MQTT 3.1.1 over TLS 1.2** and port **8883** required. For devices, prefer **X.509 CA attestation** with **DPS**. citeturn2search0turn0search15turn2search1

---

## 11. Observability — Kusto Samples

- **Message ingress / drop** (route health):
```kusto
AzureMetrics
| where ResourceProvider == "MICROSOFT.DEVICES/IOTHUBS"
| where MetricName in ("d2c.telemetry.egress.success","d2c.telemetry.egress.dropped")
| summarize sum(Total) by MetricName, bin(TimeGenerated, 5m)
```
- **Function errors**:
```kusto
AppTraces
| where _ResourceId contains "sites/func-rpm-"
| where Level == "Error"
| project TimeGenerated, Message
``` 
*Metrics reference:* IoT Hub emits platform metrics including routing latency and drops. citeturn5search13

---

## 12. Performance & Cost Notes

- **IoT Hub quotas** scale by **tier × units**; **S1: 400k msgs/day/unit, S2: 6M, S3: 300M**; design for sustained **throttle** limits and 4‑KB meter size. citeturn10search0turn10search1
- Practical guidance: compress payloads; aggregate at edge; use MQTT QoS1 only when needed; turn off verbose logging for PHI.
- **ASA** uses sliding windows; tune parallelism and partition keys.

---

## 13. BCDR

- **IoT Hub**: Enable **manual failover** to paired region; limits apply (2 failovers/failbacks per day). citeturn0search4
- **ASA**: Keep **infrastructure‑as‑code** to redeploy in DR region; store state/inputs in replicated Storage/Event Hubs if used.
- **FHIR**: AHDS is multi‑region capable; protect with CMK; test **private endpoint/DNS** failover.
- **Runbooks**: scripted DNS swap for Private Zones, APIM traffic switching, function slot swaps.

---

## 14. Compliance Mapping (sample)

- **HIPAA/HITRUST**: Apply **Regulatory Compliance initiative** and service baselines; log evidence to a **central Log Analytics** workspace; restrict access via **RBAC/Privileged Identity Management**. citeturn3search0
- **Audit**: Use **Diagnostic Settings** and **workbooks**; centrally retain logs with **immutable policies** on Storage where required. citeturn5search5
- **Data handling**: no PHI in device IDs or application logs; protect keys; rotate device certs (DPS supports roll). citeturn2search11

> The overall slide flow and formatting mirrors your prior ANF healthcare deck (CLI-first sections, appendix, and demo runbook). fileciteturn4file0

---

## 15. Anticipated Objections & Responses

- **“We need on‑prem only.”** → Use **Linux gateways** + **IoT Edge**; keep PHI local and send only derived telemetry; connect via **ExpressRoute** + **Private Link**.
- **“MQTT isn’t secure.”** → IoT Hub enforces **TLS 1.2**, device **X.509**, per‑device identity, and **Defender for IoT** threat detection. citeturn0search0turn3search3
- **“FHIR is too new for EPIC.”** → EPIC supports **FHIR R4** APIs; behavior is site‑specific → validate with the target EPIC instance before go‑live. citeturn1search1

---

## 16. Live Demo (Azure Portal + CLI)

1. Show IoT Hub **metrics** and **routes**; open **Logs** and run Kusto sample. citeturn5search1
2. Start **device-simulator** (Linux) and watch ingestion.
3. Show **ASA job** outputs; trigger **Function**; verify **FHIR Observation** created.
4. (Optional) Show **APIM** with Private Endpoint to FHIR.
5. Review **Defender for IoT** recommendations. citeturn3search3

---

## 17. Appendix — Ports & Protocols

- **MQTT** 8883 (TLS 1.2), **MQTT over WebSockets** 443, **AMQP** 5671. citeturn0search15

---

## 18. Appendix — Azure Policy commands

```bash
# Discover HIPAA/HITRUST initiative definition id
HIPAA_ID=$(az policy definition list   --query "[?contains(displayName, 'HIPAA HITRUST') && policyType=='BuiltIn'].name" -o tsv)

# Assign at subscription scope
az policy assignment create -g ""   --name hipaa-hitrust-rpm   --display-name "HIPAA/HITRUST RPM Baseline"   --policy $HIPAA_ID --scope /subscriptions/$SUB
```
*Regulatory initiative reference.* citeturn3search0

---

## 19. Appendix — OpenShift (ARO or OpenShift on‑prem)

- Use **Kubernetes Job/CronJob** to run telemetry simulator pods; mount **Secret** for device credentials; limit egress to **IoT Hub private endpoint** over **TLS**.
- See `/openshift/mqtt-simulator.yaml`.

---

## 20. Next Steps

- Replace simulator with **vendor device integration** (X.509 CA, DPS).
- Shift FHIR mapping to **MedTech service** when appropriate. citeturn4search1
- Add **AI triage** (anomaly detection) using Azure ML; secure with **CMK** and private endpoints where supported.

---

### Attributions / Key Docs
IoT Hub MQTT/TLS, ports, quotas, and DR; ASA→Functions; AHDS FHIR/DICOM/MedTech; APIM + Private Link; Azure Policy HIPAA/HITRUST; Defender for IoT. citeturn2search0turn0search0turn0search15turn10search1turn0search4turn0search2turn0search7turn8search1turn5search0turn4search1turn4search2turn3search0turn3search3
