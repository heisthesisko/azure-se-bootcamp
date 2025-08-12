# ai_model.py — Flask microservice returning top-3 predictions w/ confidence
from flask import Flask, request, jsonify
from PIL import Image
import numpy as np
import io
from tensorflow.keras.applications.efficientnet import (
    EfficientNetB0, preprocess_input, decode_predictions
)

app = Flask(__name__)
model = EfficientNetB0(weights="imagenet")

@app.route("/analyze", methods=["POST"])
def analyze_image():
    if "image" not in request.files:
        return jsonify({"error": "No image part in request"}), 400
    file = request.files["image"]
    if file.filename == "":
        return jsonify({"error": "No selected file"}), 400

    img = Image.open(io.BytesIO(file.read())).convert("RGB").resize((224, 224))
    arr = np.array(img, dtype=np.float32)
    arr = np.expand_dims(arr, axis=0)
    arr = preprocess_input(arr)

    preds = model.predict(arr)
    top3 = decode_predictions(preds, top=3)[0]

    predictions = [
        {"class_id": cid, "label": label, "confidence": float(prob)}
        for (cid, label, prob) in top3
    ]
    return jsonify({"top_label": predictions[0]["label"], "predictions": predictions})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
