#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update && sudo apt-get install -y python3 python3-venv
python3 -m venv /opt/ai && source /opt/ai/bin/activate
pip install flask pillow
sudo tee /opt/ai/app.py >/dev/null <<'PY'
from flask import Flask, request, jsonify
from datetime import datetime
app = Flask(__name__)
@app.route("/inference", methods=["POST"])
def infer():
    ts = datetime.utcnow().isoformat()
    payload = request.json or {}
    # Dummy inference
    result = {"diagnosis":"normal", "confidence":0.95, "timestamp":ts}
    print(f"[INFER] {ts} payload={payload}")
    return jsonify(result)
@app.route("/healthz")
def hz():
    return "ok"
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
PY
sudo tee /etc/systemd/system/ai.service >/dev/null <<'UNIT'
[Unit]
Description=On-Prem AI Inference Service
After=network.target
[Service]
ExecStart=/opt/ai/bin/python /opt/ai/app.py
Restart=always
[Install]
WantedBy=multi-user.target
UNIT
sudo systemctl daemon-reload
sudo systemctl enable --now ai.service
echo "AI inference service running on port 5000."
