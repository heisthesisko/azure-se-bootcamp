-- Sample schema for healthcare-like data (synthetic, no real PHI)
CREATE TABLE IF NOT EXISTS patients (
  patient_id SERIAL PRIMARY KEY,
  mrn VARCHAR(32) NOT NULL UNIQUE,
  first_name VARCHAR(64) NOT NULL,
  last_name VARCHAR(64) NOT NULL,
  dob DATE NOT NULL,
  condition_code VARCHAR(16),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS encounters (
  encounter_id SERIAL PRIMARY KEY,
  patient_id INT REFERENCES patients(patient_id),
  encounter_date TIMESTAMP NOT NULL,
  department VARCHAR(64),
  notes TEXT
);
