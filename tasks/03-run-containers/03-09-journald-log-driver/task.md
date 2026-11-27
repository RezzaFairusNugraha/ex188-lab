# Task 03-09: Routing Container Logs to journald and Querying CONTAINER_NAME Fields

## Objective
On RHEL 10, configuring containers with `--log-driver=journald` integrates container logs directly into systemd's structured journal with indexed fields like `CONTAINER_NAME=` and `SYSLOG_IDENTIFIER=`.

## Specification
1. Start detached container `journal-auditor` from `registry.access.redhat.com/ubi10/ubi-minimal:latest` with `--log-driver=journald` and `--log-opt tag=ex188-audit` running:
   `sh -c 'echo "AUDIT_EVENT_90210_READY"; sleep 3600'`
2. Query `journalctl --user` filtered by `CONTAINER_NAME=journal-auditor` and write the matching output containing `AUDIT_EVENT_90210_READY` to `/home/student/workspace/03-09/journal-extract.log`.
