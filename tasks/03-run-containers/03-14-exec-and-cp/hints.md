## Level 1 — Nudge
`podman cp <container>:<src> <host_dest>` copies out, and `podman cp <host_src> <container>:<dest>` copies in!

## Level 2 — Approach
Run both `podman cp` transfers, ensure `index.html` is readable (`chmod 0644` before copying), and run `podman exec portal-live nginx -s reload`.

## Level 3 — Key Commands
```bash
podman cp portal-live:/tmp/diag-report.txt ~/workspace/03-14/diag-report.txt
chmod 0644 ~/workspace/03-14/new-index.html
podman cp ~/workspace/03-14/new-index.html portal-live:/usr/share/nginx/html/index.html
podman exec portal-live nginx -s reload
```
