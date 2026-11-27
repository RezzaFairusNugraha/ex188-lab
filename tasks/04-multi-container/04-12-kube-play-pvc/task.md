# Task 04-12: Deploying a Multi-Container Pod and PersistentVolumeClaim with podman kube play

## Objective
When `podman kube play` encounters a `PersistentVolumeClaim` (`kind: PersistentVolumeClaim`) in a multi-document YAML file, Podman automatically creates a matching Podman named volume!

## Specification
Author `/home/student/workspace/04-12/pvc-stack.yaml` (separated by `---`) defining:
1. `PersistentVolumeClaim` named `notes-pvc` (`accessModes: [ReadWriteOnce]`, `resources.requests.storage: 1Gi`).
2. `Pod` named `notes-kube-pod` containing:
   - Container `cache` (`docker.io/library/redis:7-alpine`)
   - Container `web` (`localhost/webapp-0412:1.0`, pre-built) publishing `hostPort: 8412` -> `containerPort: 8080`, `APP_ENV=production`, `REDIS_HOST=127.0.0.1`, mounting volume `notes-storage` (`persistentVolumeClaim.claimName: notes-pvc`) at `/var/lib/webapp/data`.
3. Deploy via `podman kube play /home/student/workspace/04-12/pvc-stack.yaml` and post `kube-pvc-persisted` to `http://127.0.0.1:8412/entries`.
