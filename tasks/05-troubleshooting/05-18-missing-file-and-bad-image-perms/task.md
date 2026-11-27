# Task 05-18: Troubleshooting Image Build Exclusions and File Permission Errors

## Objective
Container `portal-0518` (`localhost/ts-portal-0518:1.0`, built from `/home/student/workspace/05-18/`) fails to serve the portal on port `8518`. Inspect `podman logs portal-0518` and the build context in `/home/student/workspace/05-18/` to identify and fix both build defects.

## Specification
As user `student`:
1. Fix the build configuration inside `/home/student/workspace/05-18/` so all required HTML assets are included in `/usr/share/nginx/html/` and `/etc/nginx/conf.d/default.conf` is readable by the unprivileged Nginx worker user.
2. Rebuild `localhost/ts-portal-0518:1.0` and recreate detached container `portal-0518` publishing `8518:8080`.
3. Verify `http://127.0.0.1:8518/` returns `Cloud-Native Operations Portal`.
