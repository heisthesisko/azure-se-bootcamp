#!/usr/bin/env python3
"""ai/infer_triage.py
A minimal example simulating an AI triage model inference on synthetic vitals.
This is a placeholder for lab purposes (NO medical use).
"""
import json, sys, random

def risk_score(vitals):
    # trivial synthetic scoring
    score = 0
    score += max(0, (vitals.get("hr", 70) - 60) / 40.0)
    score += max(0, (vitals.get("temp_c", 36.6) - 37.0) * 2)
    score += (130 - min(130, vitals.get("sbp", 120))) / 50.0
    return min(10.0, round(score, 2))

if __name__ == "__main__":
    vitals = {"hr": 88, "temp_c": 37.6, "sbp": 118}
    if len(sys.argv) > 1:
        vitals = json.loads(sys.argv[1])
    print(json.dumps({"vitals": vitals, "risk": risk_score(vitals)}))
