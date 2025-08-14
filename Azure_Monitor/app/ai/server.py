from flask import Flask, request, jsonify
from datetime import datetime
app = Flask(__name__)
@app.route("/predict", methods=["POST"])
def predict():
    ts = datetime.utcnow().isoformat()
    payload = request.json or {}
    result = {"ok": True, "prediction": "coin:quarter", "confidence": 0.93, "ts": ts}
    print(f"[PREDICT] {ts} payload={payload}")
    return jsonify(result)
@app.route("/healthz")
def hz():
    return "ok"
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
