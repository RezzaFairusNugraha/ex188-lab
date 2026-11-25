# Task 03-01: Detached Container Execution, Custom Hostname, User Override, and Ephemeral --rm Runs

## Scenario
Master core `podman run` flags (`-d`, `--name`, `--hostname`, `--user`, `--rm`) so background services maintain predictable identities and one-off jobs leave zero stopped-container clutter.

## Requirements
1. Start a detached container named `beacon-svc` (`${CNAME}` if `--seed` is active) from `registry.access.redhat.com/ubi10/ubi-minimal:latest` with:
   - Container hostname `beacon.lab.internal`
   - Runtime user `1005:1005`
   - Command `sleep 3600`
2. Run a separate **ephemeral** (`--rm`) container from `registry.access.redhat.com/ubi10/ubi-minimal:latest` that prints `uname -r`, redirecting its output to `/home/student/workspace/03-01/kernel.txt`, and verify no exited container remains in `podman ps -a`.
