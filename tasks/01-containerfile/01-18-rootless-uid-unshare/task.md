# Task 01-18: Rootless Host Directory Ownership: podman unshare vs keep-id

## Objective
The `worker-py` source files have been pre-staged in `/home/student/workspace/01-18/build/`. Build a non-root worker image (`USER 1001`) and demonstrate both standard RHEL 10 rootless bind-mount UID alignment techniques.

## Specification
As user `student`:
1. Build `localhost/worker-uid1001:1.0` from `/home/student/workspace/01-18/build/` on `registry.access.redhat.com/ubi10/ubi:latest` running as `USER 1001` with `CMD ["python3", "/opt/worker/worker.py", "--interval", "1"]`.
2. Create `/home/student/workspace/01-18/unshare-spool/inbox` and `outbox`, shift their ownership to container UID:GID `1001:1001` within the rootless user namespace (without using `keep-id`), and start detached container `worker-unshare` mounting both directories at `/var/spool/worker/inbox` and `/var/spool/worker/outbox` with private SELinux labels.
3. Create `/home/student/workspace/01-18/keepid-spool/inbox` and `outbox` (retaining host `student` ownership on the host!), and start detached container `worker-keepid` mapping host `student` to container UID:GID `1001:1001` while mounting both directories with private SELinux labels.
