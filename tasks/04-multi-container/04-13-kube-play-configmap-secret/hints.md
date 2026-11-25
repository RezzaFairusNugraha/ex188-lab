## Level 1 — Nudge
Separate `ConfigMap`, `Secret`, and `Pod` with `---` in a single YAML file — `podman kube play` applies them in document order!

## Level 2 — Approach
Put `ConfigMap` `webapp-cm` first, `Secret` `webapp-k8s-sec` (`stringData: webapp_secret: KubeSecret_8812`) second, and `Pod` `cm-sec-pod` third mounting both volumes at `/etc/webapp` and `/run/secrets`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/04-13/cm-secret-pod.yaml <<'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: webapp-cm
data:
  APP_ENV: production
  app.conf: |
    SITE_TITLE=Kube ConfigMap Portal
---
apiVersion: v1
kind: Secret
metadata:
  name: webapp-k8s-sec
stringData:
  webapp_secret: KubeSecret_8812
---
apiVersion: v1
kind: Pod
metadata:
  name: cm-sec-pod
spec:
  containers:
    - name: web
      image: localhost/webapp-0413:1.0
      ports:
        - containerPort: 8080
          hostPort: 8413
      env:
        - name: APP_ENV
          valueFrom:
            configMapKeyRef:
              name: webapp-cm
              key: APP_ENV
        - name: REQUIRE_SECRET
          value: "1"
      volumeMounts:
        - name: cfg-vol
          mountPath: /etc/webapp
          readOnly: true
        - name: sec-vol
          mountPath: /run/secrets
          readOnly: true
  volumes:
    - name: cfg-vol
      configMap:
        name: webapp-cm
        items:
          - key: app.conf
            path: app.conf
    - name: sec-vol
      secret:
        secretName: webapp-k8s-sec
EOF
podman kube play ~/workspace/04-13/cm-secret-pod.yaml
```
