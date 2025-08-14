-- Minimal schema for workshop demo
CREATE TABLE IF NOT EXISTS patients (
  patient_id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name  TEXT NOT NULL,
  dob DATE,
  gender CHAR(1),
  member_id TEXT
);
INSERT INTO patients(first_name,last_name,dob,gender,member_id)
VALUES ('Ada','Lovelace','1815-12-10','F','PLN12345')
ON CONFLICT DO NOTHING;
