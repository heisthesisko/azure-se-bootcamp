#!/usr/bin/env python3
import csv, os, random, datetime
out = "mock_phi.csv"
rows = []
for i in range(1, 201):
    dob = datetime.date(1940,1,1) + datetime.timedelta(days=random.randint(0, 30000))
    rows.append([1000+i, f"Patient{i} Test", dob.isoformat(), random.choice(["Hypertension","Type2Diabetes","Asthma","Hyperlipidemia"])])
with open(out, "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["PatientID","Name","DOB","Diagnosis"])
    w.writerows(rows)
print("Wrote", out)
