# Task 01-06: Preventing Secret and Context Bloat Leaks with .containerignore

## Scenario
The directory `/home/student/workspace/01-06/` already contains a `Containerfile` using `COPY . /opt/service/` alongside application files, a `.git/` directory, `.env.secret`, `debug.log`, and `notes.bak`. You must **not** remove those files from the host workspace, and you must **not** change `COPY . /opt/service/` in `Containerfile`.

## Requirements
1. Create `/home/student/workspace/01-06/.containerignore` so the build context excludes:
   - `.git` (and everything inside it)
   - Any file matching `*.secret` or `*.log` or `*.bak`
   - `Containerfile` and `.containerignore` themselves
2. Keep `service.py` and `config/default.json` included inside `/opt/service/`.
3. Build `localhost/clean-context:1.0` from `/home/student/workspace/01-06/`.
