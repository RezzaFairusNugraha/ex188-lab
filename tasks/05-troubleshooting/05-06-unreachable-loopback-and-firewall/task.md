# Task 05-06: Troubleshooting External Service Unreachability on Port 8506

## Objective
Container `webapp-ext-0506` (`localhost/ts-web-0506:1.0`) is running, but external clients cannot reach it on host TCP port `8506`. Inspect the container's runtime configuration, port bindings, and host firewall rules to resolve every issue blocking external traffic.

## Specification
1. Recreate `webapp-ext-0506` from `localhost/ts-web-0506:1.0` (with `APP_ENV=production`) so the application listens on all interfaces inside the container and publishes `0.0.0.0:8506->8080` on the host.
2. Open `8506/tcp` in `firewalld` both actively and permanently.
3. Verify `http://127.0.0.1:8506/healthz` returns `200 OK`.
