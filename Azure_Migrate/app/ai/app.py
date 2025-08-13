from flask import Flask, request, jsonify
from joblib import load
app = Flask(__name__)
model = load("model.joblib")  # {'coef':0.5,'intercept':3.0}

@app.route("/health", methods=["GET"])
def health():
    return jsonify(status="ok", hipaa="synthetic data only")

@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json(force=True)
    x = float(data.get("x", 0.0))
    y = model["coef"] * x + model["intercept"]
    return jsonify(prediction=y)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
