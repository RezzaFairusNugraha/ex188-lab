## Solution
```bash
cat > /home/student/workspace/04-16/kube-cm.yaml <<'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: portal-cfg
data:
  APP_ENV: production
  app.conf: |
    SITE_TITLE=Quadlet Kube Unit
EOF

cat > /home/student/workspace/04-16/kube-pod.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: qkube-pod
spec:
  containers:
    - name: redis
      image: docker.io/library/redis:7-alpine
    - name: web
      image: localhost/webapp-0416:1.0
      ports:
        - containerPort: 8080
          hostPort: 8416
      env:
        - name: REDIS_HOST
          value: 127.0.0.1
        - name: APP_ENV
          valueFrom:
            configMapKeyRef:
              name: portal-cfg
              key: APP_ENV
      volumeMounts:
        - name: cfg
          mountPath: /etc/webapp
          readOnly: true
  volumes:
    - name: cfg
      configMap:
        name: portal-cfg
        items:
          - key: app.conf
            path: app.conf
EOF

mkdir -p /home/student/.config/containers/systemd
cat > /home/student/.config/containers/systemd/qkube-app.kube <<'EOF'
[Kube]
Yaml=/home/student/workspace/04-16/kube-pod.yaml
ConfigMap=/home/student/workspace/04-16/kube-cm.yaml

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user start qkube-app.service
loginctl enable-linger student
```

## Explanation
Quadlet `.kube` units wrap `podman kube play --replace --service-container=true` on start and `podman kube down` on stop, giving Kubernetes YAML manifests native `systemd` lifecycle and reboot persistence!

## Common Mistakes
- Using relative paths instead of absolute paths (`/home/student/...`) on `Yaml=` or `ConfigMap=` inside `.kube`!
