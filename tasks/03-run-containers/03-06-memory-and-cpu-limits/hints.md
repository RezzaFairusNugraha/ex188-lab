## Level 1 — Nudge
Check `man podman-run` for `--memory`, `--memory-swap`, `--cpus`, and `--pids-limit`.

## Level 2 — Approach
Launch `quota-worker` passing `--memory 256m --memory-swap 256m --cpus 0.5 --pids-limit 64`.

## Level 3 — Key Commands
```bash
podman run -d --name quota-worker \
  --memory 256m \
  --memory-swap 256m \
  --cpus 0.5 \
  --pids-limit 64 \
  registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600
```
