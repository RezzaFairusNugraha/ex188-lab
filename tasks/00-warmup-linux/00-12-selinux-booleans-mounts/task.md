# Task 00-12: SELinux Process Domains, Persistent Booleans, and :z vs :Z Mount Labels

## Scenario
To pass SELinux-related container objectives on RHEL 10, you must inspect live process domains (`ps -Z`), toggle persistent SELinux booleans (`setsebool -P`), and observe the exact MCS label difference between shared (`:z`) and private (`:Z`) bind mounts.

## Requirements
1. Persistently enable the SELinux boolean `container_manage_cgroup` (`on` both in current runtime and persistent policy).
2. Inspect the SELinux process context of the running `firewalld` daemon and write **only its SELinux domain type** (e.g., `firewalld_t`) into `/home/student/workspace/00-12/firewalld-type.txt`.
3. Create two host directories:
   - `/home/student/workspace/00-12/shared-dir` — bind-mount it into an ephemeral `registry.access.redhat.com/ubi10/ubi-minimal:latest` container with the **shared** SELinux option (`:z`) so its context has `container_file_t:s0` (no MCS category pair).
   - `/home/student/workspace/00-12/private-dir` — bind-mount it into an ephemeral `registry.access.redhat.com/ubi10/ubi-minimal:latest` container with the **private** SELinux option (`:Z`) so its context has `container_file_t:s0:c...,c...` (specific MCS categories).
