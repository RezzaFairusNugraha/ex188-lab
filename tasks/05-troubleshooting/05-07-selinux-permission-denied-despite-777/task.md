# Task 05-07: Troubleshooting Bind-Mount Write Failure Under Enforcing SELinux

## Objective
Container `selinux-victim` (`localhost/ts-web-0507:1.0`, running as `USER 1001` on `-p 8507:8080`) fails health checks (`503` on `http://127.0.0.1:8507/healthz`) with `Permission denied` on `/var/lib/webapp/data`, even though a previous operator set `/home/student/workspace/05-07/data` to `0777`.

## Specification
1. Keep host SELinux in **Enforcing** mode and keep container SELinux confinement enabled (`setenforce 0` and `label=disable` are prohibited).
2. Restore secure `0755` permissions on `/home/student/workspace/05-07/data` (do not leave it `0777`).
3. Recreate `selinux-victim` on `-p 8507:8080` (`APP_ENV=production`, `CHECK_STORAGE=1`) mounting `/home/student/workspace/05-07/data` at `/var/lib/webapp/data` with proper SELinux labeling and rootless UID mapping so `http://127.0.0.1:8507/healthz` returns `200 OK` (`"storage": "writable"`).
