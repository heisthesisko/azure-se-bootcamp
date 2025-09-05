# app/bot_api.py (skeleton)
from fastapi import FastAPI, Request
import os, requests

app = FastAPI()

OPENAI_ENDPOINT = os.environ.get("OPENAI_ENDPOINT")
OPENAI_KEY = os.environ.get("OPENAI_KEY")
FHIR_ENDPOINT = os.environ.get("FHIR_ENDPOINT")
SEARCH_ENDPOINT = os.environ.get("SEARCH_ENDPOINT")
PG_CONN = os.environ.get("PG_CONN")

@app.get("/healthz")
def healthz():
    return {"status": "ok"}

@app.post("/api/messages")
async def messages(req: Request):
    payload = await req.json()
    user_text = payload.get("text") or ""
    # TODO: enrich with FHIR + retrieval + OpenAI
    return {"reply": f"Echo: {user_text}"}
