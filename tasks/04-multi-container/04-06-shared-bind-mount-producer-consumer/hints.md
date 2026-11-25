## Level 1 — Nudge
Whenever two or more containers mount the same host path, ALWAYS use lowercase `:z` (`s0`), never uppercase `:Z`!

## Level 2 — Approach
Create `spool/{inbox,outbox}`, start `job-consumer` with `--userns=keep-id:uid=1001,gid=1001` and `:z` mounts on `/var/spool/worker/inbox` and `/var/spool/worker/outbox`, then start `job-producer` with `:z` on `/inbox`.

## Level 3 — Key Commands
```bash
mkdir -p ~/workspace/04-06/spool/{inbox,outbox}
podman run -d --name job-consumer --userns=keep-id:uid=1001,gid=1001 \
  -v ~/workspace/04-06/spool/inbox:/var/spool/worker/inbox:z \
  -v ~/workspace/04-06/spool/outbox:/var/spool/worker/outbox:z \
  localhost/worker-0406:1.0
podman run -d --name job-producer \
  -v ~/workspace/04-06/spool/inbox:/inbox:z \
  registry.access.redhat.com/ubi10/ubi-minimal:latest \
  sh -c 'echo "order-77" > /inbox/batch1.job && sleep 3600'
```
