# Task 01-21: Adding OCI Image LABEL Metadata and Built-In HEALTHCHECK

## Scenario
Enterprise image catalogs require OCI labels and embedded container `HEALTHCHECK` definitions so orchestrators and Quadlets detect wedged workers automatically.

## Requirements
1. Copy `/home/student/apps/worker-py/` into `/home/student/workspace/01-21/` and author `Containerfile` on `registry.access.redhat.com/ubi10/ubi:latest`.
2. Add OCI `LABEL` keys:
   - `org.opencontainers.image.title="spool-worker"`
   - `org.opencontainers.image.vendor="Acme Platform"`
   - `com.example.team="cloud-ops"`
3. Configure `HEALTHCHECK` (`--interval=10s --timeout=3s --retries=2`) running `python3 /opt/worker/healthcheck.py`.
4. Run as `USER 1001` with `CMD ["python3", "/opt/worker/worker.py", "--interval", "2"]`, build `localhost/worker-labeled:1.0` (`--format docker` so OCI/Docker `HEALTHCHECK` metadata is stored!), and start detached container `worker-hc` until its health status reaches `healthy`.
