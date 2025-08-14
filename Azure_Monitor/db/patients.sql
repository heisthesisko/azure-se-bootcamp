-- Sample patients table
CREATE TABLE IF NOT EXISTS patients(
  id serial PRIMARY KEY,
  mrn varchar(32) UNIQUE,
  name text,
  dob date
);
