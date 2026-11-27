# Task 03-05: Injecting Runtime Variables via --env-file and -e Precedence

## Objective
Setup created `/home/student/workspace/03-05/base.env` containing `APP_ENV=staging`, `APP_PORT=8080`, and `LOG_LEVEL=warn`, plus built `localhost/webapp-envtest:1.0` from `webapp-flask`. You must launch a container loading `base.env` while overriding `APP_ENV` to `production` via `-e` without modifying `base.env`.

## Specification
1. Preserve `/home/student/workspace/03-05/base.env` unmodified.
2. Start detached container `env-precedence` on `-p 8305:8080` from `localhost/webapp-envtest:1.0` passing `--env-file /home/student/workspace/03-05/base.env` and `-e APP_ENV=production`.
3. Verify `curl http://127.0.0.1:8305/` reports `"env": "production"` while `LOG_LEVEL=warn` is also present inside the container.
