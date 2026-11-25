# Task 05-07: Fixing Bind-Mount Permission Denied Despite Mode 0777 (Missing SELinux Label)

## Scenario
A junior admin ran `chmod 0777 /home/student/workspace/05-07/data` to fix a write failure on `selinux-victim`, yet `curl http://127.0.0.1:8507/healthz` STILL returns `503` (`PermissionError: [Errno 13] Permission denied`)!

## Requirements
1. Do **not** disable SELinux (`setenforce 0` is strictly forbidden and fails grading!) and do **not** pass `--security-opt label=disable`.
2. Tighten `/home/student/workspace/05-07/data` permissions back from insecure `0777` to `0755` (using `--userns=keep-id:uid=1001,gid=1001`) and fix the bind mount on `selinux-victim` (`-p 8507:8080`) with proper SELinux relabeling (`:Z`) so `/healthz` (`CHECK_STORAGE=1`) returns `200 OK`!
