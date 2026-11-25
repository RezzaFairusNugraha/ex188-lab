# Task 03-06: Enforcing cgroup v2 Memory and CPU Limits (--memory, --memory-swap, --cpus)

## Scenario
RHEL 10 uses unified cgroup v2 + systemd delegation out of the box, enabling rootless Podman to enforce hard RAM, swap, and CPU quotas on containers.

## Requirements
Start detached container `quota-worker` from `registry.access.redhat.com/ubi10/ubi-minimal:latest` running `sleep 3600` with:
1. Hard memory limit of `256m` (`268435456` bytes).
2. Combined memory+swap limit of `256m` (`--memory-swap 256m`, disabling swap usage beyond RAM).
3. CPU limit of `0.5` CPUs (`--cpus 0.5`).
4. PIDs limit of `64` (`--pids-limit 64`).
