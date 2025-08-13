-- Simple schema to simulate medical imaging metadata.
-- This is generic instructional content; in production, ensure HIPAA alignment.
CREATE TABLE IF NOT EXISTS patients (
    patient_id SERIAL PRIMARY KEY,
    mrn VARCHAR(64) UNIQUE NOT NULL, -- Medical Record Number
    given_name VARCHAR(100),
    family_name VARCHAR(100),
    dob DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS studies (
    study_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id) ON DELETE CASCADE,
    modality VARCHAR(16) NOT NULL, -- e.g., CT, MR, US
    accession_number VARCHAR(64) UNIQUE,
    study_date DATE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS images (
    image_id SERIAL PRIMARY KEY,
    study_id INT REFERENCES studies(study_id) ON DELETE CASCADE,
    file_path TEXT NOT NULL,
    sha256 TEXT,
    findings TEXT,
    ai_inference JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
