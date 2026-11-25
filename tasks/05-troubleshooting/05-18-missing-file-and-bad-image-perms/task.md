# Task 05-18: Diagnosing Image Build Defects: Missing Config File and Root-Only Ownership

## Scenario
Container `portal-0518` (`localhost/ts-portal-0518:1.0` built from `/home/student/workspace/05-18/`) fails on startup (`nginx: [emerg] open() "/etc/nginx/conf.d/default.conf" failed (13: Permission denied)` and `404` on `/index.html`). Inspect the image and `/home/student/workspace/05-18/` to fix both defects!

## Requirements
1. Inspect `/home/student/workspace/05-18/.containerignore` and `/home/student/workspace/05-18/Containerfile` to find why `index.html` was excluded from the build and why `default.conf` has mode `0600` owned by `root:root` (unreadable by Nginx UID `101`).
2. Fix `.containerignore` and `Containerfile`, rebuild `localhost/ts-portal-0518:1.0`, recreate `portal-0518` on `-p 8518:8080`, and verify `http://127.0.0.1:8518/` returns `Cloud-Native Operations Portal`.
