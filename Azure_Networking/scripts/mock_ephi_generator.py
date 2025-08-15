#!/usr/bin/env python3
import os, csv, json, random, datetime
random.seed(42)
N = int(os.environ.get("COUNT","100"))
outdir = os.environ.get("OUTDIR","./assets/docs")
os.makedirs(outdir, exist_ok=True)
genders = ["male","female","unknown"]
def rand_date(start_year=1930, end_year=2020):
    y = random.randint(start_year,end_year)
    m = random.randint(1,12)
    d = random.randint(1,28)
    return f"{y:04d}-{m:02d}-{d:02d}"
rows = []
for i in range(N):
    mrn = f"MRN{100000+i}"
    row = {
        "mrn": mrn,
        "first_name": random.choice(["Alex","Jordan","Taylor","Casey","Morgan","Riley","Quinn","Avery","Sam","Jamie"]),
        "last_name": random.choice(["Lee","Patel","Garcia","Nguyen","Smith","Johnson","Wong","Kim","Chen","Walker"]),
        "dob": rand_date(),
        "gender": random.choice(genders),
        "phone": f"+1-555-{random.randint(1000,9999)}"
    }
    rows.append(row)
csv_path = os.path.join(outdir, "mock_ephi_patients.csv")
with open(csv_path,"w",newline="",encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)
json_path = os.path.join(outdir, "mock_ephi_patients.json")
with open(json_path,"w",encoding="utf-8") as f:
    json.dump(rows,f, indent=2)
print(f"Wrote {len(rows)} mock rows to:\n - {csv_path}\n - {json_path}")
