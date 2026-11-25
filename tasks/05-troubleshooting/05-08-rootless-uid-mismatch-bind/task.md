# Task 05-08: Fixing Rootless UID Ownership Mismatch on an SELinux-Labeled Bind Mount

## Scenario
Container `uid-victim` (`localhost/ts-web-0508:1.0`, running as `USER 1001`) already mounts `/home/student/workspace/05-08/journal` with `:Z` (`container_file_t`), yet `POST http://127.0.0.1:8508/entries` STILL fails with `500` (`Permission denied`)! Use `podman top uid-victim user huser` and `ls -ln` on the host directory to diagnose the rootless UID namespace mismatch!

## Requirements
1. Do **not** set `0777` permissions on `/home/student/workspace/05-08/journal` and do **not** run the container as `USER 0`.
2. Fix ownership using `podman unshare chown -R 1001:1001 /home/student/workspace/05-08/journal` (or recreate `uid-victim` with `--userns=keep-id:uid=1001,gid=1001`) so `POST http://127.0.0.1:8508/entries?msg=uid-fixed` succeeds (`201`)!
