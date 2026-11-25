# Task 02-16: Flattening a Container Filesystem with podman export and podman import --change

## Scenario
Unlike `podman save` (which operates on **images** and keeps layers + metadata), `podman export` operates on a **container** and exports a flat root filesystem tarball with **zero** image metadata (`ENV`, `USER`, `CMD`, and layer history are all stripped!). When re-importing with `podman import`, `--change` (`-c`) restores needed config instructions.

## Requirements
1. Export the filesystem of pre-created container `legacy-box` to `/home/student/workspace/02-16/rootfs.tar` using `podman export`.
2. Import `/home/student/workspace/02-16/rootfs.tar` as image `localhost/flattened-box:1.0` using `podman import`, applying `--change` flags to set:
   - `USER 1001`
   - `ENV FLATTENED=true`
   - `CMD ["cat", "/etc/custom-stamp"]`
3. Verify `localhost/flattened-box:1.0` has only **1** filesystem layer (`RootFS.Layers`) and outputs `stamp-0216` when run.
