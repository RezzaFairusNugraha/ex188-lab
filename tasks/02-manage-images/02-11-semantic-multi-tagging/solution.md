## Solution
```bash
podman tag localhost/portal-build:ci \
  registry.lab.local:5000/web/portal:2.3.1 \
  registry.lab.local:5000/web/portal:2.3 \
  registry.lab.local:5000/web/portal:2 \
  registry.lab.local:5000/web/portal:latest \
  registry.lab.local:5000/archive/portal:2.3.1

for ref in \
  registry.lab.local:5000/web/portal:2.3.1 \
  registry.lab.local:5000/web/portal:2.3 \
  registry.lab.local:5000/web/portal:2 \
  registry.lab.local:5000/web/portal:latest \
  registry.lab.local:5000/archive/portal:2.3.1; do
    podman push --tls-verify=false "${ref}"
done
```

## Explanation
After the first push uploads the blob layers to `registry.lab.local:5000`, subsequent pushes in the same registry mount existing blobs and complete almost instantaneously!

## Common Mistakes
- Forgetting that `podman push` pushes one tag per invocation (unlike `podman tag`, which accepts many targets at once).
