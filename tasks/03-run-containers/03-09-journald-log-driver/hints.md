## Level 1 — Nudge
Pass `--log-driver=journald` and `--log-opt tag=ex188-audit` to `podman run`, then pass `CONTAINER_NAME=journal-auditor` directly as a match argument to `journalctl --user`.

## Level 2 — Approach
Launch `journal-auditor` with the required log driver and command, wait 1 second, and run `journalctl --user CONTAINER_NAME=journal-auditor --no-pager > ~/workspace/03-09/journal-extract.log`.

## Level 3 — Key Commands
```bash
podman run -d --name journal-auditor \
  --log-driver=journald \
  --log-opt tag=ex188-audit \
  registry.access.redhat.com/ubi10/ubi-minimal:latest \
  sh -c 'echo "AUDIT_EVENT_90210_READY"; sleep 3600'
sleep 1
journalctl --user CONTAINER_NAME=journal-auditor --no-pager > ~/workspace/03-09/journal-extract.log
```
