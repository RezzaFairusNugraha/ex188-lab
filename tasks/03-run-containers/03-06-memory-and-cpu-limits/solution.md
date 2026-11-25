## Solution
```bash
podman run -d --name quota-worker \
  --memory 256m \
  --memory-swap 256m \
  --cpus 0.5 \
  --pids-limit 64 \
  registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600
```

## Explanation
Setting `--memory-swap` equal to `--memory` (`256m`) gives the container zero swap allowance beyond `256m` RAM. Without `--memory-swap`, Podman defaults to allowing `2x` (`512m` total RAM+swap).

## Common Mistakes
- Passing `--memory-swap 0` thinking `0` disables swap (`0` actually means "use the default 2x multiplier"!). Set `--memory-swap` equal to `--memory` to disable swap.
