## Solution
```bash
podman run -d --name admin-local -p 127.0.0.1:18081:8080 quay.io/nginx/nginx-unprivileged:1.26-alpine
podman run -d --name public-front -p 0.0.0.0:18082:8080 quay.io/nginx/nginx-unprivileged:1.26-alpine
podman port admin-local > /home/student/workspace/03-02/admin-port.txt
```

## Explanation
When `-p 127.0.0.1:18081:8080` is used, `ss -tulpn` confirms the host listener is bound to `127.0.0.1:18081` — remote machines cannot connect even if `firewalld` opens `18081/tcp`!

## Common Mistakes
- Reversing host and container ports (`-p 8080:18081` instead of `-p 18081:8080`).
