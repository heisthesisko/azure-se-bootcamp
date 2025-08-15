#!/usr/bin/env python3
import csv, random, datetime
with open("mock_phi.csv","w",newline="") as f:
  w=csv.writer(f); w.writerow(["PatientID","Name","DOB","Diagnosis"])
  for i in range(1001,1101):
    dob=datetime.date(1950,1,1)+datetime.timedelta(days=random.randint(0,25000))
    w.writerow([i, f"Patient{i}", dob.isoformat(), random.choice(["Hypertension","Type2Diabetes","Asthma","Hyperlipidemia"])])
print("mock_phi.csv created")
