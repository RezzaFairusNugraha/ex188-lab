# Task 03-15: Auditing Container Filesystem Drift with podman diff

## Scenario
An unscheduled script modified files inside running container `drift-watch`. `podman diff` categorizes OverlayFS changes into `A` (Added), `C` (Changed), and `D` (Deleted).

## Requirements
1. Run `podman diff drift-watch` and save the complete output to `/home/student/workspace/03-15/full-diff.txt`.
2. Extract **only paths marked `A` (Added)** (just the `/path` column without the leading `A `, sorted) into `/home/student/workspace/03-15/added-paths.txt`.
3. Remove the rogue file `/tmp/unauthorized-dropper.sh` inside `drift-watch` so `podman diff drift-watch` no longer lists `/tmp/unauthorized-dropper.sh`.
