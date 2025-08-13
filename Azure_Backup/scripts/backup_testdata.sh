#!/usr/bin/env bash
# Create synthetic patient/study/image data to exercise backups
set -euo pipefail
export PGHOST=${PGHOST:-127.0.0.1}
export PGPORT=${PGPORT:-5432}
export PGDATABASE=${PGDATABASE:-workshopdb}
export PGUSER=${PGUSER:-workshop}
export PGPASSWORD=${PGPASSWORD:-workshop}

psql -v ON_ERROR_STOP=1 <<'SQL'
INSERT INTO patients (mrn, given_name, family_name, dob)
SELECT 'MRN' || g, 'Test' || g, 'Patient', DATE '1980-01-01' + (g || ' days')::interval
FROM generate_series(1,25) g
ON CONFLICT DO NOTHING;

INSERT INTO studies (patient_id, modality, accession_number, study_date, description)
SELECT p.patient_id, (CASE WHEN random() < 0.5 THEN 'CT' ELSE 'MR' END),
       'ACC' || p.patient_id, CURRENT_DATE, 'Workshop Study'
FROM patients p
ON CONFLICT DO NOTHING;
SQL
echo "Seeded demo data."
