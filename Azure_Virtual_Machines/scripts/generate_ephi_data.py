#!/usr/bin/env python3
"""scripts/generate_ephi_data.py
Generate synthetic ePHI-like data for labs (patients & encounters).
Never use real PHI in labs.
"""
import random, datetime, names, psycopg2, os
from faker import Faker

def conn():
    return psycopg2.connect(
        host=os.getenv("DB_HOST","127.0.0.1"),
        port=int(os.getenv("DB_PORT","5432")),
        dbname=os.getenv("DB_NAME","postgres"),
        user=os.getenv("DB_USER","postgres"),
        password=os.getenv("DB_PASS","")
    )

def main(n=100):
    fake = Faker()
    c = conn()
    c.autocommit = True
    cur = c.cursor()
    for _ in range(n):
        first, last = names.get_first_name(), names.get_last_name()
        dob = fake.date_of_birth(minimum_age=0, maximum_age=100)
        mrn = str(random.randint(10000000, 99999999))
        cur.execute("""INSERT INTO healthcare.patients (mrn, first_name, last_name, date_of_birth, gender, phone, email)
                      VALUES (%s,%s,%s,%s,%s,%s,%s) RETURNING patient_id""", 
                    (mrn, first, last, dob, random.choice(["M","F","Other","Unknown"]), fake.phone_number(), fake.email()))
        pid = cur.fetchone()[0]
        for _ in range(random.randint(1,3)):
            cur.execute("""INSERT INTO healthcare.encounters (patient_id, encounter_dt, encounter_type, clinician, notes)
                          VALUES (%s, %s, %s, %s, %s)""",
                        (pid, fake.date_time_between(start_date='-1y', end_date='now'),
                         random.choice(["outpatient","inpatient","telehealth"]),
                         fake.name(),
                         fake.text(max_nb_chars=120)))
    cur.close()
    c.close()
    print(f"Inserted {n} patients with encounters.")

if __name__ == "__main__":
    try:
        main(50)
    except Exception as e:
        print("Note: Install dependencies first: pip install names faker psycopg2-binary") 
        print(e)
