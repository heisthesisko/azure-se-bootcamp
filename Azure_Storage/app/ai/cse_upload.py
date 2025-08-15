#!/usr/bin/env python3
import os, sys, json, base64, requests
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes

ACCOUNT=os.getenv("BLOB_ACCOUNT","")
CONTAINER=os.getenv("BLOB_CONTAINER","phi")
SAS=os.getenv("WEB_SAS","")
if not ACCOUNT or not SAS: print("Set BLOB_ACCOUNT and WEB_SAS"); sys.exit(1)

def encrypt(data: bytes):
  key=get_random_bytes(32); nonce=get_random_bytes(12)
  cipher=AES.new(key, AES.MODE_GCM, nonce=nonce)
  ct, tag = cipher.encrypt_and_digest(data)
  return key, nonce, tag, ct

def upload(name: str, data: bytes):
  key, nonce, tag, ct = encrypt(data)
  meta={"alg":"AES-256-GCM","nonce":base64.b64encode(nonce).decode(),"tag":base64.b64encode(tag).decode(),"key_demo_do_not_use":base64.b64encode(key).decode()}
  url=f"https://{ACCOUNT}.blob.core.windows.net/{CONTAINER}/{name}.enc?{SAS}"
  r=requests.put(url, data=ct, headers={"x-ms-blob-type":"BlockBlob"}); r.raise_for_status()
  r2=requests.put(f"https://{ACCOUNT}.blob.core.windows.net/{CONTAINER}/{name}.enc.meta?{SAS}", data=json.dumps(meta).encode(), headers={"x-ms-blob-type":"BlockBlob","Content-Type":"application/json"}); r2.raise_for_status()
  print("Uploaded", name)

if __name__=="__main__":
  data=b"mock ePHI"
  if len(sys.argv)>1:
    with open(sys.argv[1],"rb") as f: data=f.read()
  upload("sample_phi", data)
