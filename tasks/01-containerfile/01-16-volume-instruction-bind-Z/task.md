# Task 01-16: VOLUME Instruction and Host Bind Mount with Private SELinux Label (:Z)

## Scenario
Stateful containers declare mount points with `VOLUME` in their `Containerfile` and bind host directories at runtime using SELinux relabeling so confined container processes can write safely on RHEL 10.

## Requirements
1. Copy `/home/student/apps/webapp-flask/` into `/home/student/workspace/01-16/` and build `localhost/webapp-vol:1.0` on `registry.access.redhat.com/ubi10/ubi:latest`:
   - Declare `VOLUME ["/var/lib/webapp/data"]` in `Containerfile`.
   - Run as rootless default or `USER 0` inside rootless namespace (or `USER 1001` with `--userns=keep-id:uid=1001,gid=1001` at run time) so the container can write into the mounted host directory.
2. Create host directory `/home/student/workspace/01-16/host-notes` and start detached container `notes-writer` on `-p 8096:8080 -e APP_ENV=production` bind-mounting `/home/student/workspace/01-16/host-notes` onto `/var/lib/webapp/data` with the **private** SELinux option (`:Z`).
3. Post an entry `first-persistent-note` to `http://127.0.0.1:8096/entries` and verify `/home/student/workspace/01-16/host-notes/entries.log` exists on the host.
