#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update -y
sudo apt-get install -y python3-venv python3-pip
python3 -m venv ~/ai-venv
source ~/ai-venv/bin/activate
pip install --upgrade pip
# Install minimal CPU-only packages; GPU optional in real lab
pip install tensorflow==2.12.0 flask
cat > ~/ai-venv/app.py <<'PY'
from flask import Flask, request, jsonify
app = Flask(__name__)
@app.route("/healthz")
def healthz():
    return "ok"
@app.route("/predict", methods=["POST"])
def predict():
    # mock model: echo input length
    text = request.json.get("text","")
    return jsonify({"ok": True, "score": len(text)})
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
PY
echo "Run: source ~/ai-venv/bin/activate && python ~/ai-venv/app.py"
