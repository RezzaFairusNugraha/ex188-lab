## Level 1 — Nudge
Replace `CMD command arg1` with valid double-quoted JSON array syntax `CMD ["command", "arg1"]`.

## Level 2 — Approach
Edit `~/workspace/01-13/Containerfile` changing the last line to `CMD ["python3", "/opt/worker/worker.py"]`, build `localhost/worker-exec:1.0`, and run `podman run -d --name worker-clean localhost/worker-exec:1.0`.

## Level 3 — Key Commands
```bash
sed -i 's|^CMD .*|CMD ["python3", "/opt/worker/worker.py"]|' ~/workspace/01-13/Containerfile
podman build -t localhost/worker-exec:1.0 ~/workspace/01-13
podman run -d --name worker-clean localhost/worker-exec:1.0
```
