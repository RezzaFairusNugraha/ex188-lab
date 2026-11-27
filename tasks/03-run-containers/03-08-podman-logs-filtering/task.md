# Task 03-08: Extracting Timestamped and Stream-Filtered Container Logs

## Objective
Running container `log-emitter` has written diagnostic lines to standard output and alert messages to standard error.

## Specification
As user `student`:
1. Save **only the last 5 log lines** (stdout and stderr combined) from `log-emitter` with RFC3339 timestamps prepended on each line to `/home/student/workspace/03-08/recent-timestamped.log`.
2. Save **only standard error (`stderr`)** output from `log-emitter` (excluding `stdout` lines) to `/home/student/workspace/03-08/stderr-only.log`.
