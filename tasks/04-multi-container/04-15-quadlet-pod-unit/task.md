# Task 04-15: Multi-Container Pod Managed by a Quadlet .pod Unit Across Reboot

## Objective
Podman v5 introduced first-class **`.pod` Quadlet units**! Member `.container` files join the pod via `Pod=<name>.pod`, while port publishing lives on the `.pod` unit itself (`<name>-pod.service`).

## Specification
Inside `/home/student/.config/containers/systemd/`:
1. Create `telemetry-stack.pod`:
   - `[Pod]` `PodName=telemetry-stack` and `PublishPort=8415:8080`
   - `[Install]` `WantedBy=default.target`
2. Create `telemetry-redis.container` (`ContainerName=telemetry-redis`, `Image=docker.io/library/redis:7-alpine`, `Pod=telemetry-stack.pod`).
3. Create `telemetry-web.container` (`ContainerName=telemetry-web`, `Image=localhost/webapp-0415:1.0`, `Pod=telemetry-stack.pod`, `Environment=APP_ENV=production`, `Environment=REDIS_HOST=127.0.0.1`).
4. Reload user systemd, start `telemetry-stack-pod.service` (and member services), ensure user lingering is enabled, and verify `http://127.0.0.1:8415/healthz` returns `200 OK`.
