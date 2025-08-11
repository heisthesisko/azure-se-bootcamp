
#!/usr/bin/env python3
# Simple AI/Queue sample:
# - Upload a local file to Blob Storage (via container SAS)
# - Enqueue a message to Azure Queue (via queue SAS)
# Prereqs:
#   - After running scripts/05_sas.sh, app/web/.sas_url.txt contains a container SAS URL
#   - app/ai/.queue_sas.txt contains the queue SAS token
import os, sys, base64, json
from datetime import datetime, timezone
import requests

SA = os.environ.get("SA_NAME", "")
CONTAINER = os.environ.get("CONTAINER", "images")
if not SA:
    print("Set SA_NAME and CONTAINER env vars (source config/env.sh).")
    sys.exit(1)
if len(sys.argv) < 2:
    print("Usage: SA_NAME=<name> CONTAINER=<name> python app/ai/upload_and_queue.py /path/to/file")
    sys.exit(1)
filepath = sys.argv[1]
if not os.path.exists(filepath):
    print("File not found:", filepath)
    sys.exit(1)

# Read container SAS URL
sas_url_file = os.path.join(os.path.dirname(__file__), "..", "web", ".sas_url.txt")
with open(sas_url_file, "r") as f:
    sas_url = f.read().strip().splitlines()[-1].split(":",1)[-1].strip()

# Upload blob via SAS (PUT)
blob_name = os.path.basename(filepath)
upload_url = f"{sas_url.rsplit('?',1)[0]}/{blob_name}?{sas_url.rsplit('?',1)[1]}"
with open(filepath, "rb") as f:
    data = f.read()
r = requests.put(upload_url, data=data, headers={"x-ms-blob-type": "BlockBlob"})
print("Upload status:", r.status_code)

# Queue message using SAS
qsas_file = os.path.join(os.path.dirname(__file__), ".queue_sas.txt")
with open(qsas_file, "r") as f:
    qsas = f.read().strip().split()[-1]
queue_url = f"https://{SA}.queue.core.windows.net/jobs/messages?{qsas}"
payload = base64.b64encode(json.dumps({"blob": blob_name, "ts": datetime.now(timezone.utc).isoformat()}).encode()).decode()
r2 = requests.post(queue_url, data=f"<QueueMessage><MessageText>{payload}</MessageText></QueueMessage>",
                   headers={"Content-Type": "application/xml"})
print("Queue status:", r2.status_code)
