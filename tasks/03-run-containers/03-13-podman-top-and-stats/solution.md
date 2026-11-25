## Solution
```bash
podman top metrics-target user huser pid hpid comm > /home/student/workspace/03-13/top-map.txt
podman stats --no-stream --format "{{.Name}} {{.MemUsage}}" metrics-target > /home/student/workspace/03-13/stats.txt
```

## Explanation
`podman top <ctr> user huser` instantly reveals how container UID `1001` maps to subordinate host UID `101000` (or `student` when `keep-id` is active) — invaluable when debugging bind-mount permission errors!

## Common Mistakes
- Running `podman stats` without `--no-stream` in a script, which refreshes forever like interactive `top`.
