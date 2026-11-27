# Task 01-21: Embedding OCI Metadata Labels and Container HEALTHCHECK

## Objective
The `worker-py` source files have been pre-staged in `/home/student/workspace/01-21/`. Build an image containing required catalog labels and an active health probe.

## Specification
As user `student`:
1. Create `/home/student/workspace/01-21/Containerfile` on `registry.access.redhat.com/ubi10/ubi:latest` (`python3`, `/var/spool/worker/{inbox,outbox}` owned by `1001:1001`, `USER 1001`, `CMD ["python3", "/opt/worker/worker.py", "--interval", "2"]`).
2. Set the following image labels:
   - `org.opencontainers.image.title="spool-worker"`
   - `org.opencontainers.image.vendor="Acme Platform"`
   - `com.example.team="cloud-ops"`
3. Configure a `HEALTHCHECK` (`--interval=10s --timeout=3s --retries=2`) executing `python3 /opt/worker/healthcheck.py`.
4. Build `localhost/worker-labeled:1.0` in Docker v2s2 manifest format (`--format docker` so `HEALTHCHECK` metadata is preserved) and start detached container `worker-hc` until its status is `healthy`.
