## Solution
```bash
podman run -d --name edge-portal \
  -p 0.0.0.0:8883:8080 \
  -v /home/student/workspace/03-03/public:/usr/share/nginx/html:ro,z \
  quay.io/nginx/nginx-unprivileged:1.26-alpine

sudo firewall-cmd --permanent --add-port=8883/tcp
sudo firewall-cmd --reload
```

## Explanation
Note we used `:ro,z` (never `:Z` on shared `/home/student/apps/*` owned by `root`!) or copied the public assets into a student workspace first. On the real exam, grading connects from an external VM IP, so forgetting `firewall-cmd` loses full network points even when `curl localhost:8883` works!

## Common Mistakes
- Testing only `curl localhost:8883` (loopback bypasses `firewalld` ingress filtering!) and forgetting to open `8883/tcp` in `firewalld`.
