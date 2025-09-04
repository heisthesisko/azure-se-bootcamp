import logging, os, json, datetime
import azure.functions as func
from azure.identity import DefaultAzureCredential
import requests

FHIR_URL = os.environ.get("FHIR_URL")  # e.g., https://fhir-xxxx.azurehealthcareapis.com
cred = DefaultAzureCredential()

def get_token():
    scope = f"{FHIR_URL}/.default"
    return cred.get_token(scope).token

def build_obs(device_id, ts, code, system, display, value, unit):
    return {
      "resourceType": "Observation",
      "status": "final",
      "category": [{"coding": [{"system":"http://terminology.hl7.org/CodeSystem/observation-category","code":"vital-signs"}]}],
      "code": {"coding":[{"system": system, "code": code, "display": display}]},
      "subject": {"reference": f"Patient/{device_id}"},
      "effectiveDateTime": ts,
      "valueQuantity": {"value": value, "unit": unit, "system":"http://unitsofmeasure.org"}
    }

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

@app.route(route="triage")
def triage(req: func.HttpRequest) -> func.HttpResponse:
    try:
        body = req.get_json()
    except Exception:
        return func.HttpResponse("invalid JSON", status_code=400)

    device_id = body.get("deviceId","unknown")
    ts = body.get("ts") or datetime.datetime.utcnow().isoformat()+"Z"
    obs = []
    if body.get("hr_alert"):
        obs.append(build_obs(device_id, ts, "8867-4", "http://loinc.org", "Heart rate", body.get("hr_avg1m"), "beats/min"))
    if body.get("glu_alert"):
        obs.append(build_obs(device_id, ts, "2339-0", "http://loinc.org", "Glucose", body.get("glu_avg5m"), "mg/dL"))

    token = get_token()
    headers = {"Authorization": f"Bearer {token}", "Content-Type":"application/fhir+json"}
    results = []
    for o in obs:
        r = requests.post(f"{FHIR_URL}/Observation", headers=headers, data=json.dumps(o))
        results.append({"status": r.status_code, "text": r.text[:300]})
    return func.HttpResponse(json.dumps({"results": results}), mimetype="application/json")
