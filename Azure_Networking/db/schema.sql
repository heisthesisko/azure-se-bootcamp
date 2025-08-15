-- FHIR-adjacent sample schema (training only, not canonical FHIR)
CREATE TABLE IF NOT EXISTS patients (
    patient_id SERIAL PRIMARY KEY,
    mrn VARCHAR(64) UNIQUE NOT NULL,
    first_name VARCHAR(128),
    last_name VARCHAR(128),
    dob DATE,
    gender VARCHAR(32),
    phone VARCHAR(64),
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS encounters (
    encounter_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    encounter_ts TIMESTAMP DEFAULT NOW(),
    reason VARCHAR(256),
    facility_code VARCHAR(32)
);
