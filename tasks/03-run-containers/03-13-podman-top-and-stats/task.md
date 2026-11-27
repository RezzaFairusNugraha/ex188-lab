# Task 03-13: Auditing Live Processes and Resource Metrics with podman top and podman stats

## Objective
`podman top` exposes specialized container-aware format descriptors (`user`, `huser`, `pid`, `hpid`, `label`, `capeff`) that standard `ps` inside a container cannot see!

## Specification
Against running container `metrics-target`:
1. Run `podman top metrics-target user huser pid hpid comm` and save the output to `/home/student/workspace/03-13/top-map.txt`.
2. Capture a single non-streaming snapshot of `podman stats --no-stream --format "{{.Name}} {{.MemUsage}}"` for `metrics-target` into `/home/student/workspace/03-13/stats.txt`.
