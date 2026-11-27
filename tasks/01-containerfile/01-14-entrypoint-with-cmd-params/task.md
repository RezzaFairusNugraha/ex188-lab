# Task 01-14: Appliance Container Pattern with ENTRYPOINT and Default CMD

## Objective
The `worker-py` application (`worker.py`, `healthcheck.py`, and `README.md`) has been pre-staged in `/home/student/workspace/01-14/`. Package it as an appliance container whose executable entrypoint is fixed while default CLI flags remain overridable at `podman run`.

## Specification
As user `student`:
1. Create `/home/student/workspace/01-14/Containerfile` based on `registry.access.redhat.com/ubi10/ubi:latest`:
   - Install `python3` and clean package metadata.
   - Copy `worker.py` and `healthcheck.py` into `/opt/worker/`.
   - Create `/var/spool/worker/inbox` and `/var/spool/worker/outbox` writable by numeric UID `1001`.
   - Run as numeric `USER 1001`.
   - Configure exec-form `ENTRYPOINT ["python3", "/opt/worker/worker.py"]` and default exec-form `CMD ["--interval", "5", "--prefix", "DEFAULT"]`.
2. Build the image as `localhost/worker-appliance:1.0`.
3. Start two detached containers from `localhost/worker-appliance:1.0`:
   - `worker-default` using the image's default arguments.
   - `worker-fast` overriding only the runtime arguments to `--interval 1 --prefix FAST`.
