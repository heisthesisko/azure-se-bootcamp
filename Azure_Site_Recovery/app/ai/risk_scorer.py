#!/usr/bin/env python3
import json, os
ROOT = os.path.dirname(os.path.dirname(__file__))
BUNDLE = os.path.join(ROOT, "assets", "mock_data", "patients.json")
def load_bundle():
    with open(BUNDLE,"r",encoding="utf-8") as f: return json.load(f)
if __name__=="__main__":
    b=load_bundle(); print(f"Loaded {len(b.get('entry',[]))} entries (synthetic).")
