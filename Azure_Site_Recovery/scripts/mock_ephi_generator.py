#!/usr/bin/env python3
import os, json, random, uuid, datetime, csv
ROOT = os.path.dirname(os.path.dirname(__file__))
OUTDIR = os.path.join(ROOT, "assets", "mock_data")
os.makedirs(OUTDIR, exist_ok=True)
random.seed(42)
first_names = ["Alex","Maria","John","Priya","Chen","Aisha","Noah","Liam","Emma","Olivia","Sophia","Ethan"]
last_names  = ["Smith","Johnson","Wang","Patel","Garcia","Brown","Davis","Miller","Rodriguez","Martinez","Lopez"]
genders     = ["male","female","other","unknown"]
obs_codes   = [("718-7","Hemoglobin","g/dL", 11.0, 17.0),("8480-6","Systolic BP","mmHg",105,160),("8462-4","Diastolic BP","mmHg",60,100),("2951-2","Sodium","mmol/L",132,145)]
def random_date(start_year=1940, end_year=2010):
    start = datetime.date(start_year,1,1).toordinal()
    end   = datetime.date(end_year,12,31).toordinal()
    d = datetime.date.fromordinal(random.randint(start, end))
    return d
def fake_patient(i):
    pid = str(uuid.uuid4())
    fn = random.choice(first_names); ln = random.choice(last_names)
    gender = random.choice(genders); dob = random_date().isoformat()
    return {"resourceType":"Patient","id":pid,"name":[{"use":"official","family":ln,"given":[fn]}],
            "gender":gender,"birthDate":dob,"identifier":[{"system":"https://example.org/mrn","value":f"MRN{i:06d}"}]}
def fake_observation(patient_id):
    code = random.choice(obs_codes); value = round(random.uniform(code[3], code[4]), 1)
    return {"resourceType":"Observation","id":str(uuid.uuid4()),"status":"final",
            "code":{"coding":[{"system":"http://loinc.org","code":code[0],"display":code[1]}]},
            "subject":{"reference":f"Patient/{patient_id}"},
            "effectiveDateTime": datetime.datetime.utcnow().isoformat(),
            "valueQuantity":{"value":value,"unit":code[2],"system":"http://unitsofmeasure.org"}}
def generate(n=50):
    bundle={"resourceType":"Bundle","type":"collection","entry":[]}; rows=[]
    for i in range(1,n+1):
        p=fake_patient(i); bundle["entry"].append({"resource":p})
        for _ in range(random.randint(1,3)):
            o=fake_observation(p["id"]); bundle["entry"].append({"resource":o})
            rows.append({"mrn":p["identifier"][0]["value"],"patient_id":p["id"],
                        "name":f"{p['name'][0]['given'][0]} {p['name'][0]['family']}",
                        "gender":p["gender"],"birthDate":p["birthDate"],
                        "loinc":o["code"]["coding"][0]["code"],"observation":o["code"]["coding"][0]["display"],
                        "value":o["valueQuantity"]["value"],"unit":o["valueQuantity"]["unit"],
                        "effective":o["effectiveDateTime"]})
    with open(os.path.join(OUTDIR,"patients.json"),"w",encoding="utf-8") as jf: json.dump(bundle,jf,indent=2)
    with open(os.path.join(OUTDIR,"patients.csv"),"w",newline="",encoding="utf-8") as cf:
        writer=csv.DictWriter(cf,fieldnames=list(rows[0].keys())); writer.writeheader(); writer.writerows(rows)
if __name__=="__main__":
    generate(); print(f"Wrote synthetic ePHI to {OUTDIR}")
