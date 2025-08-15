CREATE TABLE IF NOT EXISTS patients (
  patient_id INT PRIMARY KEY,
  name TEXT NOT NULL,
  dob DATE NOT NULL,
  diagnosis TEXT
);

CREATE TABLE IF NOT EXISTS claims (
  claim_id SERIAL PRIMARY KEY,
  patient_id INT NOT NULL REFERENCES patients(patient_id),
  claim_date DATE NOT NULL,
  amount NUMERIC(12,2) NOT NULL,
  status TEXT CHECK (status IN ('Submitted','Adjudicated','Paid','Denied')) NOT NULL DEFAULT 'Submitted'
);

CREATE TABLE IF NOT EXISTS imaging_metadata (
  image_id SERIAL PRIMARY KEY,
  patient_id INT NOT NULL REFERENCES patients(patient_id),
  dicom_uid TEXT NOT NULL,
  modality TEXT,
  stored_in TEXT DEFAULT 'blob://phi/',
  created_at TIMESTAMP DEFAULT now()
);
