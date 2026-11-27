# Task 01-22: Pruning Stopped Containers and Dangling Images Safely

## Objective
Clean up stopped containers and untagged dangling build layers on the workstation while keeping active services running.

## Specification
As user `student`:
1. Keep running container `keep-alive-svc` active and untouched.
2. Remove all stopped/exited containers (`exited-job-1`, `exited-job-2`) and prune all dangling (`<none>`) images from local storage.
3. Save the output of `podman system df` after cleanup to `/home/student/workspace/01-22/system-df.txt`.
