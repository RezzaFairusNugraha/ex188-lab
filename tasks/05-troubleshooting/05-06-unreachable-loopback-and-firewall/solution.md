## Solution
```bash
podman rm -f webapp-ext-0506
podman run -d --name webapp-ext-0506 \
  -p 0.0.0.0:8506:8080 \
  -e APP_ENV=production \
  -e APP_BIND=0.0.0.0 \
  localhost/ts-web-0506:1.0

sudo firewall-cmd --permanent --add-port=8506/tcp
sudo firewall-cmd --reload
```

## Explanation
Inside a container network namespace, `127.0.0.1` is **only** the container's own loopback — packets arriving via port forwarding enter on the container's `eth0`/`tap0` interface, so containerized servers must bind `0.0.0.0`!

## Common Mistakes
- Fixing `-p 0.0.0.0:8506:8080` while leaving `APP_BIND=127.0.0.1` set inside the container.
