## Solution
```bash
sudo setsebool -P container_manage_cgroup on
printf 'firewalld_t\n' > /home/student/workspace/00-12/firewalld-type.txt

podman run --rm -v /home/student/workspace/00-12/shared-dir:/mnt:z \
  registry.access.redhat.com/ubi10/ubi-minimal:latest true

podman run --rm -v /home/student/workspace/00-12/private-dir:/mnt:Z \
  registry.access.redhat.com/ubi10/ubi-minimal:latest true
```

## Explanation
- `:z` (lowercase) sets `system_u:object_r:container_file_t:s0`, allowing **multiple** containers to share the same bind mount.
- `:Z` (uppercase) adds unique MCS categories (`s0:c123,c456`) matching **only** that single container instance — if a second container mounts a `:Z` directory later, the first container immediately loses SELinux access!

## Common Mistakes
- Omitting `-P` on `setsebool`, causing the boolean to revert to `off` after reboot.
- Using `:Z` on a directory shared between two containers (e.g., an API writer and a worker reader), breaking the first container.
