# Task 03-08: Filtering Container Logs with Timestamps and Tail Counts

## Scenario
Running container `log-emitter` wrote 20 numbered lines (`LINE-01` .. `LINE-20`) to stdout and 3 alert lines (`ALERT-A`, `ALERT-B`, `ALERT-C`) to stderr.

## Requirements
1. Save **only the last 5 log lines** with prepended RFC3339 timestamps (`podman logs -t --tail 5`) from `log-emitter` to `/home/student/workspace/03-08/recent-timestamped.log` (combining stdout and stderr).
2. Capture **only stderr** lines from `log-emitter` (discarding stdout) into `/home/student/workspace/03-08/stderr-only.log`.
