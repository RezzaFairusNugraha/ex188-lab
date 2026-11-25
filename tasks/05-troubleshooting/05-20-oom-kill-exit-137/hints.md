## Level 1 — Nudge
Record `State.OOMKilled` and `HostConfig.Memory` **before** removing the crashed `batch-mem-0520` container!

## Level 2 — Approach
1. Run `podman inspect --format 'OOMKILLED={{.State.OOMKilled}}\nOLD_MEMORY_BYTES={{.HostConfig.Memory}}' batch-mem-0520 > ~/workspace/05-20/oom-report.env`.
2. Remove `batch-mem-0520` and start it again with `--memory 128m --memory-swap 128m`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/05-20/oom-report.env <<EOF
OOMKILLED=$(podman inspect --format '{{.State.OOMKilled}}' batch-mem-0520)
OLD_MEMORY_BYTES=$(podman inspect --format '{{.HostConfig.Memory}}' batch-mem-0520)
EOF
podman rm -f batch-mem-0520
podman run -d --name batch-mem-0520 --memory 128m --memory-swap 128m localhost/ts-mem-0520:1.0
```
