# Task 02-14: Archiving and Restoring Full Image Metadata with podman save and podman load

## Objective
`podman save` archives all layers, `ENV`, `USER`, `CMD`, `ENTRYPOINT`, and `history` of an image into a portable tarball. Setup built `localhost/backup-demo:1.0` with `USER 1001` and `ENV BACKUP_TIER=gold`.

## Specification
1. Archive `localhost/backup-demo:1.0` using `podman save` in **`oci-archive`** format to `/home/student/workspace/02-14/backup-demo-oci.tar`.
2. Remove `localhost/backup-demo:1.0` from local Podman storage (`podman rmi`), then restore it from `/home/student/workspace/02-14/backup-demo-oci.tar` using `podman load` so `localhost/backup-demo:1.0` exists again with `USER 1001` and `ENV BACKUP_TIER=gold` intact.
