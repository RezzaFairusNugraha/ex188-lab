# Task 01-22: Container and Image Lifecycle Cleanup: Prune and podman system df

## Scenario
Setup created exited containers (`exited-job-1`, `exited-job-2`), dangling `<none>:<none>` build layers, and one active container (`keep-alive-svc`) that **must remain running**.

## Requirements
1. Without stopping or removing `keep-alive-svc`:
   - Remove all stopped/exited containers (`podman container prune -f`).
   - Remove all dangling untagged images (`podman image prune -f`).
2. Save the output of `podman system df` after cleanup to `/home/student/workspace/01-22/system-df.txt`.
