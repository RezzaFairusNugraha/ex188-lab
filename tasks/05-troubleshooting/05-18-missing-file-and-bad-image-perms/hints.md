## Level 1 — Nudge
Always check `.containerignore` (`ls -la ~/workspace/05-18`) when expected files are missing inside an image, and check `COPY --chmod=0644` when non-root UID `101` gets `Permission denied` reading config files!

## Level 2 — Approach
Remove `*.html` from `~/workspace/05-18/.containerignore`, add `--chmod=0644` (or `chmod 0644 conf/nginx.conf`) on `COPY`, rebuild `localhost/ts-portal-0518:1.0`, and recreate `portal-0518` on `-p 8518:8080`.

## Level 3 — Key Commands
```bash
rm -f ~/workspace/05-18/.containerignore
chmod 0644 ~/workspace/05-18/conf/nginx.conf
podman build -t localhost/ts-portal-0518:1.0 ~/workspace/05-18
podman rm -f portal-0518
podman run -d --name portal-0518 -p 8518:8080 localhost/ts-portal-0518:1.0
```
