-- PostgreSQL schema for images table
CREATE DATABASE imagedb;
\c imagedb;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS images (
  id SERIAL PRIMARY KEY,
  uploaded_at TIMESTAMPTZ DEFAULT now(),
  img_data BYTEA NOT NULL,
  top_label TEXT,
  top_confidence NUMERIC(6,5),
  predictions JSONB
);
