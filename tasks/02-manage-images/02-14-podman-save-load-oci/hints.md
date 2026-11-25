## Level 1 — Nudge
Check `man podman-save` — note that default format is `docker-archive`, so pass `--format oci-archive` explicitly!

## Level 2 — Approach
Run `podman save --format oci-archive -o ~/workspace/02-14/backup-demo-oci.tar localhost/backup-demo:1.0`, remove the local image with `podman rmi`, and restore with `podman load -i ~/workspace/02-14/backup-demo-oci.tar`.

## Level 3 — Key Commands
```bash
podman save --format oci-archive -o ~/workspace/02-14/backup-demo-oci.tar localhost/backup-demo:1.0
podman rmi localhost/backup-demo:1.0
podman load -i ~/workspace/02-14/backup-demo-oci.tar
```
