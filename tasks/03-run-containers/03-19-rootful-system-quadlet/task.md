# Task 03-19: Deploying a Rootful System-Scope Quadlet in /etc/containers/systemd

## Scenario
While most EX188 tasks run rootless as `student`, system-wide services (such as host-level ingress proxies or system daemons) use **rootful** Quadlets placed in `/etc/containers/systemd/` and managed via `sudo systemctl` with `WantedBy=multi-user.target`!

## Requirements
1. Create `/etc/containers/systemd/sys-gateway.container` running `quay.io/nginx/nginx-unprivileged:1.26-alpine`:
   - `ContainerName=sys-gateway`
   - `PublishPort=8089:8080`
   - `[Service]` `Restart=always`
   - `[Install]` `WantedBy=multi-user.target`
2. Validate with `sudo /usr/lib/systemd/system-generators/podman-system-generator --dryrun`, reload the **system** systemd manager (`sudo systemctl daemon-reload`), and start `sys-gateway.service`.
3. Open `8089/tcp` permanently in `firewalld` and reload.
