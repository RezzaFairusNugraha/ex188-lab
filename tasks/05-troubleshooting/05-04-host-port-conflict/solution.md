## Solution
```bash
podman ps --format 'table {{.Names}}\t{{.Ports}}'
podman rm -f rogue-squatter-0504
podman start prod-portal-0504
```

## Explanation
Always check **both** `podman ps` (rootless containers), `sudo podman ps` (rootful containers), and `sudo ss -tulpn` (host processes like host `httpd`/`nginx`) when diagnosing `address already in use`!

## Common Mistakes
- Running `podman rm -fa`, accidentally destroying `legit-neighbor-0504`!
