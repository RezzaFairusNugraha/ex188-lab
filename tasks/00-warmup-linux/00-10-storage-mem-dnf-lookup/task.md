# Task 00-10: Filesystem Inspection, Memory Metrics, and DNF Package Discovery

## Scenario
When authoring minimal `Containerfile` `RUN` layers on UBI10, you frequently need to look up which RPM package provides a specific binary (`dnf provides`) and verify host storage/memory headroom (`df`, `free`).

## Requirements
Create `/home/student/workspace/00-10/host-audit.env` containing these three exact `KEY=VALUE` lines (no quotes, no `export`):
1. `ROOT_FSTYPE=<filesystem type mounted on />` (e.g., `xfs` or `ext4`, matching `df -T /`).
2. `TOTAL_MEM_MIB=<total system RAM in MiB as reported by free -m>`.
3. `SEMANAGE_RPM=<base RPM package name that provides /usr/sbin/semanage>` (without version/release/arch suffix, e.g. `policycoreutils-python-utils`).
