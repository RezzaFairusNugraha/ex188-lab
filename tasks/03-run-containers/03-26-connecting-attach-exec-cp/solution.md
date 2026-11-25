## Solution
```bash
# 1. Inspect the passcode via podman exec:
podman exec -it console-repl cat /etc/repl-passcode

# 2. Attach to PID 1 stdin, send UNLOCK REPL-7741, and detach with Ctrl-P Ctrl-Q:
podman attach console-repl
#   UNLOCK REPL-7741
#   <Ctrl-P> <Ctrl-Q>

# 3. Copy artifacts out and in via podman cp:
podman cp console-repl:/tmp/repl-unlocked.token /home/student/workspace/03-26/unlocked.token
printf 'ACK_BY_STUDENT\n' > /home/student/workspace/03-26/operator-ack.txt
podman cp /home/student/workspace/03-26/operator-ack.txt console-repl:/tmp/operator-ack.txt
```

## Explanation
- `podman attach` connects directly to the TTY/stdin stream of **PID 1**. Typing `exit` or `Ctrl-D` closes stdin (or exits a PID 1 shell, stopping the container!), whereas the escape sequence **`Ctrl-P` `Ctrl-Q`** (customizable via `--detach-keys`) detaches cleanly leaving the container running!
- `podman exec -it <ctr> /bin/sh` launches an independent process inside the container namespaces; typing `exit` only closes that temporary shell.

## Common Mistakes
- Pressing `Ctrl-C` inside `podman attach` without `--sig-proxy=false`, which forwards `SIGINT` straight to PID 1 and kills the container!
