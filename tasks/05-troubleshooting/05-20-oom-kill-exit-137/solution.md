## Solution
```bash
cat > /home/student/workspace/05-20/oom-report.env <<EOF
OOMKILLED=$(podman inspect --format '{{.State.OOMKilled}}' batch-mem-0520)
OLD_MEMORY_BYTES=$(podman inspect --format '{{.HostConfig.Memory}}' batch-mem-0520)
EOF

podman rm -f batch-mem-0520
podman run -d --name batch-mem-0520 \
  --memory 128m \
  --memory-swap 128m \
  localhost/ts-mem-0520:1.0
```

## Explanation
Exit code **`137`** (`128 + SIGKILL(9)`) with zero application error logs almost always points to the Linux cgroup v2 OOM killer — instantly confirmed by `podman inspect --format '{{.State.OOMKilled}}'`!

## Common Mistakes
- Removing `batch-mem-0520` *before* reading `State.OOMKilled` and `HostConfig.Memory`!
