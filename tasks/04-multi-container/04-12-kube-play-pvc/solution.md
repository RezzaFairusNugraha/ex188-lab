## Solution
```bash
cat > /home/student/workspace/04-12/pvc-stack.yaml <<'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: notes-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: notes-kube-pod
spec:
  containers:
    - name: cache
      image: docker.io/library/redis:7-alpine
    - name: web
      image: localhost/webapp-0412:1.0
      ports:
        - containerPort: 8080
          hostPort: 8412
      env:
        - name: APP_ENV
          value: production
        - name: REDIS_HOST
          value: 127.0.0.1
      volumeMounts:
        - name: notes-storage
          mountPath: /var/lib/webapp/data
  volumes:
    - name: notes-storage
      persistentVolumeClaim:
        claimName: notes-pvc
EOF

podman kube play /home/student/workspace/04-12/pvc-stack.yaml
sleep 2
curl -fsS -X POST 'http://127.0.0.1:8412/entries?msg=kube-pvc-persisted'
```

## Explanation
Note that `podman kube down pvc-stack.yaml` stops/removes the Pod while preserving the `notes-pvc` named volume unless `--force` is passed!

## Common Mistakes
- Using `podman kube down --force` accidentally during restarts when you wanted to preserve PVC data!
