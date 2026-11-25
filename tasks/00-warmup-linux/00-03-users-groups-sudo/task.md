# Task 00-03: Local Service Account, Supplementary Groups, and Sudo Drop-In

## Scenario
Rootful and rootless container workflows frequently rely on dedicated host accounts with predictable numeric UIDs and scoped `sudo` privileges.

## Requirements
1. Create a group named `containerops` with GID `2450`.
2. Create a local user named `svcrunner` with numeric UID `2401` (or `TARGET_UID` if `--seed` is active), login shell `/sbin/nologin`, and supplementary group `containerops`.
3. Create a validated sudoers drop-in at `/etc/sudoers.d/ex188-svcrunner` (mode `0440`) allowing user `student` to execute `/usr/bin/id` as `svcrunner` without a password (`sudo -u svcrunner /usr/bin/id`).
