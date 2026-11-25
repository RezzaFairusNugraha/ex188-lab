## Solution
```bash
podman pod create --name portal-pod -p 8402:8080
podman run -d --name pod-redis --pod portal-pod docker.io/library/redis:7-alpine
podman run -d --name pod-web --pod portal-pod \
  -e APP_ENV=production \
  -e REDIS_HOST=127.0.0.1 \
  localhost/webapp-0402:1.0
```

## Explanation
Just like Kubernetes Pods, all containers in `portal-pod` share the `infra` container's loopback interface (`127.0.0.1`), so `pod-web` reaches Redis at `127.0.0.1:6379`!

## Common Mistakes
- Trying to pass `-p 8402:8080` on `podman run --pod portal-pod ...` (`Error: cannot set port bindings on an existing container network namespace`).
