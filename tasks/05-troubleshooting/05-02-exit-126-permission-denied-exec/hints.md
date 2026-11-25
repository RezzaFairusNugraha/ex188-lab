## Level 1 — Nudge
Exit code `126` means the target file exists, but the kernel refused `execve` (missing `+x` execute bit!).

## Level 2 — Approach
Add `--chmod=0755` on `COPY` (or `chmod +x start-worker.sh`) in `~/workspace/05-02/Containerfile`, rebuild `localhost/ts-worker-0502:1.0`, remove old `worker-0502`, and `podman run -d --name worker-0502 localhost/ts-worker-0502:1.0`.

## Level 3 — Key Commands
```bash
chmod 0755 ~/workspace/05-02/start-worker.sh
podman build -t localhost/ts-worker-0502:1.0 ~/workspace/05-02
podman rm -f worker-0502
podman run -d --name worker-0502 localhost/ts-worker-0502:1.0
```
