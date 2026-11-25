## Solution
```bash
cat > /home/student/workspace/04-13/cm-secret-pod.yaml <<'EOF'
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

podman kube play /home/student/workspace/04-13/cm-secret-pod.yaml
```

## Explanation
`stringData:` in a Kubernetes `Secret` lets you write plain UTF-8 strings directly in YAML without error-prone manual `base64` encoding (where `echo '...' | base64` often sneaks in `\n`)!

## Common Mistakes
- Putting the `Pod` document *above* `ConfigMap`/`Secret` in the YAML file — `podman kube play` processes documents top-to-bottom and fails if the referenced Secret doesn't exist yet!
