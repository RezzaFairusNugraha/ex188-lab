## Solution
```bash
podman export -o /home/student/workspace/02-16/rootfs.tar legacy-box

podman import \
  --change 'USER 1001' \
  --change 'ENV FLATTENED=true' \
  --change 'CMD ["cat", "/etc/custom-stamp"]' \
  /home/student/workspace/02-16/rootfs.tar \
  localhost/flattened-box:1.0
```

## Explanation
`podman export` dumps the merged container filesystem directly (no `manifest.json`, no `oci-layout`, no layers). Consequently `podman import` creates a brand-new single-layer image with empty `CMD`/`ENV`/`USER` unless `--change` restores them!

## Common Mistakes
- Trying `podman load -i rootfs.tar` on an exported container tarball (`Error: payload does not match any of the supported image formats`).
