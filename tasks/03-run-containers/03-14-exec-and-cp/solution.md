## Solution
```bash
podman cp portal-live:/tmp/diag-report.txt /home/student/workspace/03-14/diag-report.txt
chmod 0644 /home/student/workspace/03-14/new-index.html
podman cp /home/student/workspace/03-14/new-index.html portal-live:/usr/share/nginx/html/index.html
podman exec portal-live nginx -s reload
```

## Explanation
`podman cp` works on both running and stopped containers — making it ideal for recovering config files from crashed containers during troubleshooting!

## Common Mistakes
- Copying a `0600` file owned by root/student into a container running as UID `101` (`nginx`), resulting in `403 Forbidden` when Nginx tries to read `index.html`!
