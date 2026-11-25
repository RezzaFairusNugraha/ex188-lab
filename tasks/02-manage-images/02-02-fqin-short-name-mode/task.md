# Task 02-02: Fully Qualified Image Names (FQIN) and User registries.conf short-name-mode

## Scenario
Short image names like `ubi-minimal:latest` are vulnerable to registry spoofing in automated scripts if `unqualified-search-registries` is misordered. Podman v5 reads per-user registry configuration from `~/.config/containers/registries.conf` when running rootless.

## Requirements
As user `student`:
1. Create `~/.config/containers/registries.conf` setting:
   - `unqualified-search-registries = ["registry.access.redhat.com", "quay.io"]` (excluding `docker.io`).
   - `short-name-mode = "enforcing"`
2. Pull `registry.access.redhat.com/ubi10/ubi-minimal:latest` using its **Fully Qualified Image Name (FQIN)** and tag it locally as `localhost/fqin-verified:1.0`.
