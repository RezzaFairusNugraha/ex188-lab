# Task 03-11: Extracting Container State with podman inspect --format Go Templates

## Objective
Setup created two containers: running `inspect-live` (on custom network `net-0311`) and exited `inspect-crashed` (which exited with a non-zero code).

## Specification
Using `podman inspect --format` Go templates, create `/home/student/workspace/03-11/summary.env` containing these four exact unquoted `KEY=VALUE` lines:
1. `LIVE_IP=<IPv4 address of inspect-live on network net-0311>`
2. `LIVE_PID=<numeric host PID of inspect-live>`
3. `CRASH_EXIT_CODE=<numeric exit code of inspect-crashed>`
4. `CRASH_STARTED_AT=<State.StartedAt timestamp string of inspect-crashed>`
