## Level 1 — Nudge
Removing the last tag with `podman rmi` deletes the image layers, whereas `podman untag <image>` removes all names while preserving the untagged image ID!

## Level 2 — Approach
1. Run `podman image inspect --format '{{.Id}}' localhost/keep-layers:1.0 > ~/workspace/02-12/kept-id.txt`.
2. Run `podman untag localhost/keep-layers:1.0` (with no specific tag arguments, `podman untag` removes **all** tags from that image!).
3. Run `podman rmi localhost/purge-completely:1.0`.

## Level 3 — Key Commands
```bash
podman image inspect --format '{{.Id}}' localhost/keep-layers:1.0 > ~/workspace/02-12/kept-id.txt
podman untag localhost/keep-layers:1.0
podman rmi localhost/purge-completely:1.0
```
