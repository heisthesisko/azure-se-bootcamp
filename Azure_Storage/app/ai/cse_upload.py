#!/usr/bin/env python3
"""Client-side encryption upload demo (AES-GCM) before sending to Azure Blob via SAS).
Training-only code; do not use in production without full key management.
"""
import os, sys, json, base64
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes
import requests

ACCOUNT = os.getenv("BLOB_ACCOUNT", "")
CONTAINER = os.getenv("BLOB_CONTAINER", "phi")
SAS = os.getenv("WEB_SAS", "")
if not ACCOUNT or not SAS:
    print("Set BLOB_ACCOUNT and WEB_SAS environment variables.", file=sys.stderr)
    sys.exit(1)

def encrypt_bytes(data: bytes):
    key = get_random_bytes(32)  # AES-256
    nonce = get_random_bytes(12)
    cipher = AES.new(key, AES.MODE_GCM, nonce=nonce)
    ct, tag = cipher.encrypt_and_digest(data)
    return key, nonce, tag, ct

def upload(name: str, data: bytes):
    key, nonce, tag, ct = encrypt_bytes(data)
    # store envelope alongside ciphertext
    meta = {
        "alg": "AES-256-GCM",
        "nonce": base64.b64encode(nonce).decode(),
        "tag": base64.b64encode(tag).decode(),
        "key_b64_demo_DO_NOT_USE": base64.b64encode(key).decode()  # training only
    }
    url = f"https://{ACCOUNT}.blob.core.windows.net/{CONTAINER}/{name}.enc?{SAS}"
    r = requests.put(url, data=ct, headers={"x-ms-blob-type": "BlockBlob"})
    r.raise_for_status()
    # upload metadata
    r2 = requests.put(f"https://{ACCOUNT}.blob.core.windows.net/{CONTAINER}/{name}.enc.meta?{SAS}",
                      data=json.dumps(meta).encode("utf-8"),
                      headers={"x-ms-blob-type": "BlockBlob", "Content-Type": "application/json"})
    r2.raise_for_status()
    print("Uploaded:", name)

if __name__ == "__main__":
    payload = b"example ePHI - training only"
    if len(sys.argv) > 1:
        with open(sys.argv[1], "rb") as f:
            payload = f.read()
    upload("sample_phi", payload)
