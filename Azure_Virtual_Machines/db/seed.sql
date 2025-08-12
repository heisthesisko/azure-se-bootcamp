INSERT INTO health.patients (mrn, first_name, last_name, dob) VALUES
('MRN0001','Alice','Mendoza','1985-02-14'),
('MRN0002','Brian','Nguyen','1979-10-05');

INSERT INTO health.intake_forms (patient_id, symptoms, triage_level) VALUES
(1,'Headache, mild fever','P3'),
(2,'Shortness of breath','P2');
