# Task 05-01: Troubleshooting Immediate Container Failure (Exit Code 127 — Command Not Found)

## Objective
Container `broken-web-0501` failed to start (`State.ExitCode == 127`). Do **not** rebuild its image `localhost/ts-web-0501:1.0` — diagnose the broken `Entrypoint` / `Cmd` on `localhost/ts-web-0501:1.0` via `podman inspect` / `podman ps -a`, find where `app.py` actually lives inside the image, and recreate `broken-web-0501` cleanly!

## Specification
1. Record the numeric exit code of the initial failed attempt (`127`) into `/home/student/workspace/05-01/initial-exit.txt`.
2. Without rebuilding `localhost/ts-web-0501:1.0`, remove and recreate detached container `broken-web-0501` on `-p 8501:8080 -e APP_ENV=production` overriding `--entrypoint` / command so `webapp-flask` runs and `http://127.0.0.1:8501/healthz` returns `200 OK`.
