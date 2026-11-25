## Level 1 — Nudge
Check `man podman-export` and `man podman-import` (specifically `--change` / `-c`).

## Level 2 — Approach
Run `podman export -o ~/workspace/02-16/rootfs.tar legacy-box`, then run `podman import` with three `--change` flags (`USER 1001`, `ENV FLATTENED=true`, `CMD ["cat", "/etc/custom-stamp"]`) targeting `localhost/flattened-box:1.0`.

## Level 3 — Key Commands
```bash
podman export -o ~/workspace/02-16/rootfs.tar legacy-box
podman import \
  --change 'USER 1001' \
  --change 'ENV FLATTENED=true' \
  --change 'CMD ["cat", "/etc/custom-stamp"]' \
  ~/workspace/02-16/rootfs.tar localhost/flattened-box:1.0
```
