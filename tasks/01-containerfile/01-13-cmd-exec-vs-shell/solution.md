## Solution
```bash
sed -i 's|^CMD .*|CMD ["python3", "/opt/worker/worker.py"]|' /home/student/workspace/01-13/Containerfile
podman build -t localhost/worker-exec:1.0 /home/student/workspace/01-13
podman run -d --name worker-clean localhost/worker-exec:1.0
```

## Explanation
JSON exec form requires **double quotes** (`["python3", ...]`). Single quotes (`['python3', ...]`) are invalid JSON and silently fall back to `/bin/sh -c`!

## Common Mistakes
- Writing `CMD ['python3', '/opt/worker/worker.py']` with single quotes — invalid JSON causes Podman to execute it via `/bin/sh -c`!
