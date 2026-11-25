## Level 1 — Nudge
Without `-m` (`--multi-image-archive`), `podman save` rejects or drops extra image names! Check `man podman-save`.

## Level 2 — Approach
Run `podman save -m --format docker-archive -o ~/workspace/02-15/stack-bundle.tar localhost/bundle-web:1.0 localhost/bundle-api:1.0`, remove both images, and restore via `podman load -i`.

## Level 3 — Key Commands
```bash
podman save -m --format docker-archive -o ~/workspace/02-15/stack-bundle.tar \
  localhost/bundle-web:1.0 localhost/bundle-api:1.0
podman rmi localhost/bundle-web:1.0 localhost/bundle-api:1.0
podman load -i ~/workspace/02-15/stack-bundle.tar
```
