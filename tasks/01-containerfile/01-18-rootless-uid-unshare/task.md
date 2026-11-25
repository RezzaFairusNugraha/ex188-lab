# Task 01-18: Rootless UID Mapping with podman unshare chown vs --userns=keep-id

## Scenario
In default rootless Podman user namespaces:
- Host UID `student` (`1000`) maps to UID `0` inside the container.
- Container UID `1001` maps to a subordinate host UID (`100000 + 1001 - 1 = 101000`).
Therefore, a container running as `USER 1001` **cannot** write to a host directory owned by `student` unless you either (a) shift host directory ownership via `podman unshare chown 1001:1001`, or (b) map `student` directly to the container's UID via `--userns=keep-id:uid=1001,gid=1001` (or `:U` mount option).

## Requirements
1. Build `localhost/worker-uid1001:1.0` from `/home/student/apps/worker-py/` (copied into `/home/student/workspace/01-18/build/`) running as `USER 1001` (`CMD ["python3", "/opt/worker/worker.py", "--interval", "1"]`).
2. Prepare `/home/student/workspace/01-18/unshare-spool/{inbox,outbox}` using `podman unshare chown -R 1001:1001` (without `--userns=keep-id`) and run detached container `worker-unshare` mounting `inbox` and `outbox` with `:Z`.
3. Prepare `/home/student/workspace/01-18/keepid-spool/{inbox,outbox}` (kept owned by host `student`!) and run detached container `worker-keepid` using `--userns=keep-id:uid=1001,gid=1001` mounting `inbox` and `outbox` with `:Z`.
4. Verify both containers successfully process a `.job` file into their respective `outbox/` directory!
