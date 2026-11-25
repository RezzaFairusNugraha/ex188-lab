## Solution
```bash
podman run -d --name journal-auditor \
  --log-driver=journald \
  --log-opt tag=ex188-audit \
  registry.access.redhat.com/ubi10/ubi-minimal:latest \
  sh -c 'echo "AUDIT_EVENT_90210_READY"; sleep 3600'

sleep 1
journalctl --user CONTAINER_NAME=journal-auditor --no-pager \
  > /home/student/workspace/03-09/journal-extract.log
```

## Explanation
`journald` is RHEL 10's default/native log backend for systemd-integrated containers, allowing logs to survive even after `podman rm` deletes a container!

## Common Mistakes
- Querying `sudo journalctl` without `--user` or `journalctl` for rootless user journal entries when user journal splitting is active.
