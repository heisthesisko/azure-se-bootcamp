from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse
from PIL import Image
import io, numpy as np, os

app = FastAPI(title="Imaging Inference (Training)")

# Toy "model": edge count heuristic to simulate confidence.
def pseudo_model(img: Image.Image):
    arr = np.array(img.convert("L").resize((128, 128)))
    edges = np.abs(np.diff(arr, axis=0)).mean() + np.abs(np.diff(arr, axis=1)).mean()
    # Normalize and pretend it's a "finding" score
    score = float(min(1.0, edges / 50.0))
    finding = "possible-nodule" if score > 0.35 else "normal"
    return finding, score

@app.post("/infer")
async def infer(file: UploadFile = File(...)):
    try:
        content = await file.read()
        img = Image.open(io.BytesIO(content))
        finding, score = pseudo_model(img)
        return JSONResponse({"finding": finding, "confidence": round(score, 3)})
    except Exception as e:
        return JSONResponse({"error": "failed to process image"}, status_code=400)

@app.get("/healthz")
def healthz():
    return {"status": "ok"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("imaging_infer:app", host="0.0.0.0", port=int(os.getenv("PORT", "8080")))
