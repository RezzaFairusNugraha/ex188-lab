# Task 03-04: Binding Privileged Low Ports (<1024) in Rootless Podman via Persistent sysctl

## Objective
By default on Linux, rootless users cannot bind host TCP ports below `1024` (`net.ipv4.ip_unprivileged_port_start = 1024`). You must run a **rootless** container as `student` bound to host port **`443`** (or **`808`**, specifically **`808/tcp`** here so port 80/443 remain free) and make the kernel parameter persist across reboots!

## Specification
1. Configure a persistent sysctl drop-in `/etc/sysctl.d/90-ex188-lowports.conf` setting `net.ipv4.ip_unprivileged_port_start = 800` and apply it immediately (`sysctl --system`).
2. As rootless user `student` (**not** `sudo podman`), start detached container `lowport-web` from `quay.io/nginx/nginx-unprivileged:1.26-alpine` publishing host port `808` -> container port `8080`.
3. Open `808/tcp` permanently in `firewalld` and reload.
