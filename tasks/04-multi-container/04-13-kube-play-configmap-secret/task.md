# Task 04-13: Injecting Kubernetes ConfigMap and Secret Manifests via podman kube play

## Scenario
`podman kube play` natively consumes Kubernetes `ConfigMap` (`envFrom` or volume mounts) and `Secret` (`stringData` / base64 `data`) manifests —either embedded in the YAML or passed via `--configmap`!

## Requirements
Create `/home/student/workspace/04-13/cm-secret-pod.yaml` containing:
1. A `ConfigMap` named `webapp-cm` with `APP_ENV: production` and `app.conf` containing `SITE_TITLE=Kube ConfigMap Portal`.
2. A `Secret` named `webapp-k8s-sec` (`stringData:` `webapp_secret: KubeSecret_8812`).
3. A `Pod` named `cm-sec-pod` running `localhost/webapp-0413:1.0` (`hostPort: 8413` -> `containerPort: 8080`) that:
   - Injects `APP_ENV` from `webapp-cm` (`envFrom` or `valueFrom.configMapKeyRef`) and sets `REQUIRE_SECRET=1`.
   - Mounts `webapp-cm` (`app.conf` at `/etc/webapp/app.conf`) and mounts `webapp-k8s-sec` at `/run/secrets` (`/run/secrets/webapp_secret`).
4. Deploy with `podman kube play` and verify `http://127.0.0.1:8413/` returns `"site_title": "Kube ConfigMap Portal"` and `"secret_loaded": true`.
