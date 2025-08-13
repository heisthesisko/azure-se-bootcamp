# Mock medical imaging inference script for workshop demos.
# In a real scenario, load a trained model and run inference on DICOM/PNG files.
# This script simulates inference and writes JSON output.
import json, hashlib, time, os, sys

def sha256_file(path):
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        while True:
            chunk = f.read(8192)
            if not chunk: break
            h.update(chunk)
    return h.hexdigest()

def fake_infer(image_path):
    # Pretend to run a CNN and produce a classification with confidence.
    # WARNING: Not for clinical use.
    label = "no_finding"
    conf = 0.98
    if "fracture" in image_path.lower():
        label = "fx_suspected"
        conf = 0.91
    return {"label": label, "confidence": conf, "ts": time.time()}

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python inference.py <image_path>")
        sys.exit(2)
    image = sys.argv[1]
    if not os.path.exists(image):
        print(f"File not found: {image}")
        sys.exit(1)

    result = {
        "image": image,
        "sha256": sha256_file(image),
        "inference": fake_infer(image)
    }
    print(json.dumps(result, indent=2))
