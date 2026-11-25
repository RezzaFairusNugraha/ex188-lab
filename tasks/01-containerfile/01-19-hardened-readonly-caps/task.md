# Task 01-19: Hardened Runtime Execution: --read-only, --tmpfs, --cap-drop=ALL, and no-new-privileges

## Scenario
Security compliance requires running `webapp-flask` with an immutable root filesystem, zero Linux capabilities, `no-new-privileges`, and ephemeral RAM-backed `/tmp`.

## Requirements
1. Build `localhost/webapp-hardened:1.0` from `/home/student/apps/webapp-flask/` (copied into `/home/student/workspace/01-19/`) running as `USER 1001` on port `8080`.
2. Start detached container `hardened-web` on `-p 8099:8080 -e APP_ENV=production` with **all** of these hardening flags:
   - Root filesystem mounted read-only (`--read-only`)
   - Ephemeral writable `/tmp` via `--tmpfs /tmp:rw,noexec,nosuid,size=64m`
   - All Linux capabilities dropped (`--cap-drop=ALL`)
   - Privilege escalation blocked (`--security-opt=no-new-privileges`)
3. Verify `http://127.0.0.1:8099/healthz` returns `200 OK` while `podman exec hardened-web touch /opt/webapp/tamper` fails with `Read-only file system`.
