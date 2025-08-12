-- PostgreSQL schema for healthcare training (synthetic data only)
CREATE SCHEMA IF NOT EXISTS health AUTHORIZATION CURRENT_USER;

CREATE TABLE IF NOT EXISTS health.patients (
  patient_id SERIAL PRIMARY KEY,
  mrn VARCHAR(32) UNIQUE NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  dob DATE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS health.intake_forms (
  intake_id SERIAL PRIMARY KEY,
  patient_id INT REFERENCES health.patients(patient_id) ON DELETE CASCADE,
  symptoms TEXT,
  triage_level VARCHAR(10),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS health.imaging_studies (
  study_id SERIAL PRIMARY KEY,
  patient_id INT REFERENCES health.patients(patient_id) ON DELETE CASCADE,
  modality VARCHAR(16),
  dicom_uri TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
