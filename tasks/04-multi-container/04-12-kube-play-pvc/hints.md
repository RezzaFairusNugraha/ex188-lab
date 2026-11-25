## Level 1 — Nudge
Check `man podman-kube-play` for an example of `PersistentVolumeClaim` + `volumes: - name: ... persistentVolumeClaim: claimName: notes-pvc`.

## Level 2 — Approach
Write `pvc-stack.yaml` with the PVC document first (`---`) and Pod `notes-kube-pod` second, run `podman kube play ~/workspace/04-12/pvc-stack.yaml`, and `curl -X POST 'http://127.0.0.1:8412/entries?msg=kube-pvc-persisted'`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/04-12/pvc-stack.yaml <<'EOF'
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
podman kube play ~/workspace/04-12/pvc-stack.yaml
sleep 2
curl -fsS -X POST 'http://127.0.0.1:8412/entries?msg=kube-pvc-persisted'
```
