## Level 1 — Nudge
`sysctl -w` alone is lost on reboot! Write `net.ipv4.ip_unprivileged_port_start = 800` into `/etc/sysctl.d/90-ex188-lowports.conf` and load it with `sudo sysctl --system`.

## Level 2 — Approach
1. Create `/etc/sysctl.d/90-ex188-lowports.conf` and run `sudo sysctl --system`.
2. As `student`, run `podman run -d --name lowport-web -p 808:8080 quay.io/nginx/nginx-unprivileged:1.26-alpine`.
3. Open `808/tcp` permanently in `firewalld`.

## Level 3 — Key Commands
```bash
echo 'net.ipv4.ip_unprivileged_port_start = 800' | sudo tee /etc/sysctl.d/90-ex188-lowports.conf
sudo sysctl --system
podman run -d --name lowport-web -p 808:8080 quay.io/nginx/nginx-unprivileged:1.26-alpine
sudo firewall-cmd --permanent --add-port=808/tcp && sudo firewall-cmd --reload
```
