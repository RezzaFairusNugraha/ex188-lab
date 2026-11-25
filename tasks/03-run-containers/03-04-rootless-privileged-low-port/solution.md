## Solution
```bash
printf 'net.ipv4.ip_unprivileged_port_start = 800\n' | sudo tee /etc/sysctl.d/90-ex188-lowports.conf >/dev/null
sudo sysctl --system

podman run -d --name lowport-web -p 808:8080 quay.io/nginx/nginx-unprivileged:1.26-alpine
sudo firewall-cmd --permanent --add-port=808/tcp
sudo firewall-cmd --reload
```

## Explanation
Notice the container **still** listens on unprivileged port `8080` internally (`-p 808:8080`), while rootless `pasta` binds privileged host port `808` thanks to `net.ipv4.ip_unprivileged_port_start = 800`.

## Common Mistakes
- Running `sudo podman run ...` (creates a rootful container invisible to `student`'s `podman ps`!).
- Using `sudo sysctl -w` without writing `/etc/sysctl.d/*.conf` (fails after reboot!).
