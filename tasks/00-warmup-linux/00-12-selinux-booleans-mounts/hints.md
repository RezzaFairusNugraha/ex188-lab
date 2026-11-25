## Level 1 — Nudge
Use `setsebool -P` for persistent boolean changes, `ps -efZ` to inspect process labels (`user:role:type:level`), and `podman run --rm -v host:container:z` vs `:Z`.

## Level 2 — Approach
1. Run `sudo setsebool -P container_manage_cgroup on`.
2. Inspect `ps -efZ | grep firewalld` and extract the third colon-separated field (`firewalld_t`) into `firewalld-type.txt`.
3. Run `podman run --rm -v ~/workspace/00-12/shared-dir:/mnt:z registry.access.redhat.com/ubi10/ubi-minimal:latest true` and repeat with `:Z` on `private-dir`.

## Level 3 — Key Commands
```bash
sudo setsebool -P container_manage_cgroup on
echo 'firewalld_t' > ~/workspace/00-12/firewalld-type.txt
podman run --rm -v ~/workspace/00-12/shared-dir:/mnt:z \
  registry.access.redhat.com/ubi10/ubi-minimal:latest true
podman run --rm -v ~/workspace/00-12/private-dir:/mnt:Z \
  registry.access.redhat.com/ubi10/ubi-minimal:latest true
ls -dZ ~/workspace/00-12/shared-dir ~/workspace/00-12/private-dir
```
