# Task 03-03: Exposing a Rootless Web Service Publicly with firewalld

## Objective
Static web content has been pre-staged in `/home/student/workspace/03-03/public`. Deploy an Nginx container accessible across all host network interfaces and open the host firewall persistently.

## Specification
As user `student` (using `sudo` for host firewall configuration):
1. Start detached container `edge-portal` from `quay.io/nginx/nginx-unprivileged:1.26-alpine`:
   - Publish container port `8080` on host port `8883` (`${EXT_PORT}` if `--seed` is active) across all IPv4 interfaces (`0.0.0.0`).
   - Mount `/home/student/workspace/03-03/public` **read-only** onto `/usr/share/nginx/html` with a shared SELinux label.
2. Open TCP port `8883/tcp` (`${EXT_PORT}/tcp`) in `firewalld` both in the active runtime configuration and permanently across reboots.
3. Verify `http://127.0.0.1:8883/` returns `Cloud-Native Operations Portal`.
