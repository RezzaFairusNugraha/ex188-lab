# Task 03-06: Enforcing Container Memory, Swap, CPU, and PID Quotas

## Objective
Deploy a rootless background container subject to strict cgroup v2 resource limits on RHEL 10.

## Specification
As user `student`, start detached container `quota-worker` from `registry.access.redhat.com/ubi10/ubi-minimal:latest` executing `sleep 3600` with:
1. Hard RAM limit: `256m` (`268435456` bytes).
2. Combined RAM + swap limit: `256m` (preventing any swap usage beyond RAM).
3. CPU quota: `0.5` CPUs.
4. Maximum process count (PIDs limit): `64`.
