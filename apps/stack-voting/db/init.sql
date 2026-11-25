CREATE TABLE IF NOT EXISTS votes (
    id SERIAL PRIMARY KEY,
    choice VARCHAR(64) NOT NULL,
    cast_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO votes (choice) VALUES ('Podman Quadlet'), ('Podman Quadlet'), ('Kubernetes YAML');
