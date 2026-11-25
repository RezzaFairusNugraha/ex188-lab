# Task 01-14: Combining Fixed ENTRYPOINT with Overridable Default CMD Flags

## Scenario
Read `/home/student/apps/worker-py/README.md`. You must package `worker-py` as an appliance-style container where the Python binary and script are fixed in `ENTRYPOINT`, default flags `--interval 5 --prefix DEFAULT` live in `CMD`, and operators can pass replacement CLI flags at `podman run` without retyping `python3 /opt/worker/worker.py`.

## Requirements
1. Copy `/home/student/apps/worker-py/` into `/home/student/workspace/01-14/` and author `Containerfile` on `registry.access.redhat.com/ubi10/ubi:latest`.
2. Install `python3`, copy `worker.py` and `healthcheck.py` to `/opt/worker/`, create `/var/spool/worker/inbox` and `/var/spool/worker/outbox` writable by UID `1001`, and set `USER 1001`.
3. Configure exec-form `ENTRYPOINT ["python3", "/opt/worker/worker.py"]` and exec-form `CMD ["--interval", "5", "--prefix", "DEFAULT"]`.
4. Build `localhost/worker-appliance:1.0`.
5. Run two detached containers:
   - `worker-default` with no extra arguments (uses default `CMD`).
   - `worker-fast` overriding only `CMD` arguments to `--interval 1 --prefix FAST`.
