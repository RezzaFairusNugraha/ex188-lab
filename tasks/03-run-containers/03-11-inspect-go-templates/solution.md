## Solution
```bash
cat > /home/student/workspace/03-11/summary.env <<EOF
LIVE_IP=$(podman inspect --format '{{(index .NetworkSettings.Networks "net-0311").IPAddress}}' inspect-live)
LIVE_PID=$(podman inspect --format '{{.State.Pid}}' inspect-live)
CRASH_EXIT_CODE=$(podman inspect --format '{{.State.ExitCode}}' inspect-crashed)
CRASH_STARTED_AT=$(podman inspect --format '{{.State.StartedAt}}' inspect-crashed)
EOF
```

## Explanation
Go templates treat `-` as an illegal identifier character in `.Networks.net-0311`. Using `index <map> "<key>"` (or iterating `{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}`) works cleanly for any network or label name containing hyphens or dots!

## Common Mistakes
- Querying `.NetworkSettings.IPAddress` (top-level default network field), which is empty `""` whenever a container attaches to a user-defined CNI/Netavark network!
