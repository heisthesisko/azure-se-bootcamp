INSERT INTO patients (mrn, first_name, last_name, dob, gender, phone) VALUES
('MRN1001','Alice','Nguyen','1984-02-09','female','+1-555-1001'),
('MRN1002','Benjamin','Carter','1979-12-01','male','+1-555-1002'),
('MRN1003','Chloe','Singh','1992-08-14','female','+1-555-1003')
ON CONFLICT DO NOTHING;
INSERT INTO encounters (patient_id, reason, facility_code) VALUES
(1,'Chest pain','ED'), (2,'Routine checkup','OP'), (3,'MRI imaging','RAD');
