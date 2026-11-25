## Level 1 — Nudge
Inside `uid-victim`, `ls -ldn /var/lib/webapp/data` shows owner `0:0` (`student`), while `id` shows `uid=1001`! You can fix ownership *live* from the host with `podman unshare chown` without even restarting `uid-victim`!

## Level 2 — Approach
Run `podman unshare chown -R 1001:1001 ~/workspace/05-08/journal` (or recreate `uid-victim` with `--userns=keep-id:uid=1001,gid=1001`), then test `curl -X POST 'http://127.0.0.1:8508/entries?msg=uid-fixed'`.

## Level 3 — Key Commands
```bash
podman unshare chown -R 1001:1001 ~/workspace/05-08/journal
curl -fsS -X POST 'http://127.0.0.1:8508/entries?msg=uid-fixed'
```
