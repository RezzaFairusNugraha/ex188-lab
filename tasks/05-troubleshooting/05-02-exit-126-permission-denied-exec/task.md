# Task 05-02: Troubleshooting Exit Code 126 (Non-Executable Wrapper Script in Containerfile)

## Objective
`/home/student/workspace/05-02/` holds a `Containerfile` and `start-worker.sh` whose container `worker-0502` refuses to start with OCI permission error / exit code **`126`** (`permission denied` when invoking `/opt/worker/start-worker.sh`).

## Specification
1. Fix the permission defect in `/home/student/workspace/05-02/Containerfile` (without editing `worker.py`), rebuild `localhost/ts-worker-0502:1.0`, and recreate running container `worker-0502`.
2. Verify `worker-0502` stays `running` and emits `worker-py started` in `podman logs worker-0502`.
