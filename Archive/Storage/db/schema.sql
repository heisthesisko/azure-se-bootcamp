
CREATE TABLE IF NOT EXISTS storage_workshop_log (
    id SERIAL PRIMARY KEY,
    event_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    event_type TEXT NOT NULL,
    details JSONB
);
