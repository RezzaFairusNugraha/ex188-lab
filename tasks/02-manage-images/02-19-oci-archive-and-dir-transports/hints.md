## Level 1 — Nudge
Check `man containers-transports` or `man podman-pull`! `podman pull dir:/path` prints the imported Image ID so you can `podman tag <ID> localhost/from-dir:1.0`.

## Level 2 — Approach
1. Run `ID=$(podman pull -q dir:/home/student/workspace/02-19/unpacked-dir)` and `podman tag "$ID" localhost/from-dir:1.0`.
2. Run `podman load -i ~/workspace/02-19/bundle-oci.tar` (or `podman pull oci-archive:...`).
3. Run `mkdir -p ~/workspace/02-19/exported-dir` and `podman push localhost/from-dir:1.0 dir:/home/student/workspace/02-19/exported-dir`.

## Level 3 — Key Commands
```bash
ID=$(podman pull -q dir:/home/student/workspace/02-19/unpacked-dir)
podman tag "$ID" localhost/from-dir:1.0
podman load -i ~/workspace/02-19/bundle-oci.tar
mkdir -p ~/workspace/02-19/exported-dir
podman push localhost/from-dir:1.0 dir:/home/student/workspace/02-19/exported-dir
```
