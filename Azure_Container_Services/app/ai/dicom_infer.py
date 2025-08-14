#!/usr/bin/env python3
from flask import Flask, request, jsonify
import random
app = Flask(__name__)
@app.route("/healthz") 
def healthz(): return {"status":"ok"}
@app.route("/infer", methods=["POST"])
def infer():
    classes = ["NORMAL", "FRACTURE_SUSPECT", "ARTIFACT"]
    return jsonify({"inference": random.choice(classes), "confidence": round(random.uniform(0.6,0.95),2)})
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
