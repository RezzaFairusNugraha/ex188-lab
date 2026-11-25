# Task 01-13: Exec-Form CMD vs Shell-Form PID 1 and Clean SIGTERM Shutdown

## Scenario
`/home/student/workspace/01-13/Containerfile` wraps `worker.py` in shell-form `CMD python3 /opt/worker/worker.py`. Consequently, `/bin/sh -c` becomes PID 1 inside the container, swallows `SIGTERM`, and forces `podman stop` to wait 10 seconds before sending `SIGKILL`.

## Requirements
1. Fix `/home/student/workspace/01-13/Containerfile` so `CMD` uses JSON **exec form** (`["python3", "/opt/worker/worker.py"]`) with no shell wrapper.
2. Build `localhost/worker-exec:1.0` and start detached container `worker-clean`.
3. Verify `python3` is PID `1` inside `worker-clean` (`podman top worker-clean pid comm`).
