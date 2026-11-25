# Task 03-11: Extracting Container State with podman inspect --format Go Templates

## Scenario
On the EX188 exam workstation, external JSON parsers may not be installed — `podman inspect --format` Go templates work everywhere out of the box! Setup created two containers: running `inspect-live` (on custom network `net-0311`) and exited `inspect-crashed` (which exited with a non-zero code).

## Requirements
Using `podman inspect --format` Go templates, create `/home/student/workspace/03-11/summary.env` containing these four exact unquoted `KEY=VALUE` lines:
1. `LIVE_IP=<IPv4 address of inspect-live on network net-0311>`
2. `LIVE_PID=<numeric host PID of inspect-live>`
3. `CRASH_EXIT_CODE=<numeric exit code of inspect-crashed>`
4. `CRASH_STARTED_AT=<State.StartedAt timestamp string of inspect-crashed>`
