## Level 1 — Nudge
When a Go map key contains a hyphen (`"net-0311"`), dot access `.Networks.net-0311` fails — use `(index .NetworkSettings.Networks "net-0311").IPAddress`!

## Level 2 — Approach
Query `.State.Pid` and `(index .NetworkSettings.Networks "net-0311").IPAddress` on `inspect-live`, and `.State.ExitCode` + `.State.StartedAt` on `inspect-crashed`, writing all four lines into `summary.env`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/03-11/summary.env <<EOF
LIVE_IP=$(podman inspect --format '{{(index .NetworkSettings.Networks "net-0311").IPAddress}}' inspect-live)
LIVE_PID=$(podman inspect --format '{{.State.Pid}}' inspect-live)
CRASH_EXIT_CODE=$(podman inspect --format '{{.State.ExitCode}}' inspect-crashed)
CRASH_STARTED_AT=$(podman inspect --format '{{.State.StartedAt}}' inspect-crashed)
EOF
```
