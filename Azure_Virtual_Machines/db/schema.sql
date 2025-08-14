-- db/schema.sql : Simple healthcare test schema (synthetic ePHI ONLY)
CREATE SCHEMA IF NOT EXISTS healthcare;

CREATE TABLE IF NOT EXISTS healthcare.patients (
  patient_id SERIAL PRIMARY KEY,
  mrn VARCHAR(32) UNIQUE NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  date_of_birth DATE NOT NULL,
  gender VARCHAR(16),
  phone VARCHAR(32),
  email VARCHAR(128),
  created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS healthcare.encounters (
  encounter_id SERIAL PRIMARY KEY,
  patient_id INT NOT NULL REFERENCES healthcare.patients(patient_id),
  encounter_dt TIMESTAMP NOT NULL,
  encounter_type VARCHAR(64) NOT NULL, -- e.g., outpatient, inpatient, telehealth
  clinician VARCHAR(128),
  notes TEXT,
  created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS healthcare.dicom_images (
  image_id SERIAL PRIMARY KEY,
  patient_id INT NOT NULL REFERENCES healthcare.patients(patient_id),
  study_uid VARCHAR(64) NOT NULL,
  series_uid VARCHAR(64) NOT NULL,
  sop_instance_uid VARCHAR(64) NOT NULL,
  modality VARCHAR(16) NOT NULL, -- e.g., CT, MR, XR
  storage_uri TEXT,              -- e.g., path or blob URL
  created_at TIMESTAMP DEFAULT now()
);
