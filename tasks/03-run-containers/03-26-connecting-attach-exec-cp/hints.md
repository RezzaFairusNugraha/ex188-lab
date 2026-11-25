## Level 1 — Nudge
Read `/etc/repl-passcode` via `podman exec`, then attach to `console-repl` with `podman attach console-repl`, type `UNLOCK <code >` + Enter, and press **`Ctrl-P` then `Ctrl-Q`** to detach without stopping PID 1! Finally transfer both files with `podman cp`.

## Level 2 — Approach
1. Run `podman exec -it console-repl sh -c 'cat /etc/repl-passcode'` -> `REPL-7741`.
2. Run `podman attach console-repl`, type `UNLOCK REPL-7741`, press Enter, then press `Ctrl-P` `Ctrl-Q` (or in non-interactive shell: `printf 'UNLOCK REPL-7741\n' | socat ...` / `podman attach` with detach sequence `printf 'UNLOCK REPL-7741\r\x10\x11'`).
3. Copy `/tmp/repl-unlocked.token` out and `operator-ack.txt` in with `podman cp`.

## Level 3 — Key Commands
```bash
podman exec -it console-repl cat /etc/repl-passcode
# Interactive attach:
podman attach console-repl
# Type: UNLOCK REPL-7741  <Enter>, then press Ctrl-P followed by Ctrl-Q

podman cp console-repl:/tmp/repl-unlocked.token ~/workspace/03-26/unlocked.token
echo 'ACK_BY_STUDENT' > ~/workspace/03-26/operator-ack.txt
podman cp ~/workspace/03-26/operator-ack.txt console-repl:/tmp/operator-ack.txt
```
