# Task 05-08: Troubleshooting Rootless UID Mismatch on an SELinux-Labeled Mount

## Objective
Container `uid-victim` (`localhost/ts-web-0508:1.0`, running as `USER 1001` on `-p 8508:8080`) mounts `/home/student/workspace/05-08/journal` with a valid `container_file_t` SELinux label, yet `POST http://127.0.0.1:8508/entries` fails with HTTP `500` (`Permission denied`).

## Specification
1. Keep the container process running as UID `1001` (do not switch to `USER 0`) and do **not** set `0777` permissions on `/home/student/workspace/05-08/journal`.
2. Resolve the rootless UID ownership mismatch so `POST http://127.0.0.1:8508/entries?msg=uid-fixed` returns `201` and writes `/home/student/workspace/05-08/journal/entries.log`.
