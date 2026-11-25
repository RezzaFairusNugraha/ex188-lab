## Solution
```bash
podman inspect --format '{{.State.ExitCode}}' broken-web-0501 # or check OCI error (127)
printf '127\n' > /home/student/workspace/05-01/initial-exit.txt

podman rm -f broken-web-0501
podman run -d --name broken-web-0501 \
  -p 8501:8080 \
  -e APP_ENV=production \
  --entrypoint python3 \
  localhost/ts-web-0501:1.0 /opt/webapp/app.py
```

## Explanation
Linux/OCI exit code `127` means **command/binary not found** (`ENOENT` on `execve`). Overriding `--entrypoint python3` with trailing `/opt/webapp/app.py` bypasses the broken image `ENTRYPOINT` without rebuilding.

## Common Mistakes
- Passing `python3 /opt/webapp/app.py` as trailing `CMD` arguments *without* `--entrypoint`, which appends them to `/usr/bin/python3-nonexistent`!
