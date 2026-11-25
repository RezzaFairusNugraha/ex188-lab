## Solution
```bash
podman logs -t --tail 5 log-emitter > /home/student/workspace/03-08/recent-timestamped.log 2>&1
podman logs log-emitter >/dev/null 2> /home/student/workspace/03-08/stderr-only.log
```

## Explanation
Because `podman logs` replays container stdout to host stdout and container stderr to host stderr, redirecting `>` without `2>&1` misses stderr lines! Always add `2>&1` when capturing full container logs, or `>/dev/null 2> file` to isolate stderr.

## Common Mistakes
- Running `podman logs -t --tail 5 log-emitter > recent-timestamped.log` without `2>&1`, losing the `ALERT-*` lines written to stderr!
