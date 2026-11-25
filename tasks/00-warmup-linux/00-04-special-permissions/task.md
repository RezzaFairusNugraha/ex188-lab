# Task 00-04: Shared Directory Permissions: Setgid, Sticky Bit, and Group Ownership

## Scenario
Two host directories under `/srv/ex188-00-04` will back shared workloads and must enforce strict POSIX special permission bits.

## Requirements
1. Ensure group `devshare` exists (GID `2460`).
2. Create `/srv/ex188-00-04/collab` owned by `root:devshare` with permissions `2775` (`drwxrwsr-x`) so newly created files automatically inherit group `devshare`.
3. Create `/srv/ex188-00-04/dropoff` owned by `root:root` with permissions `1777` (`drwxrwxrwt`) so any user can create files but cannot delete files owned by other users.
4. Create a verification file `/srv/ex188-00-04/collab/ready.txt` and verify its group owner is `devshare`.
