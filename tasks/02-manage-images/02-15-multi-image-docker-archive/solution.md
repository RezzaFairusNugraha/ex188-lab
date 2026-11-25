## Solution
```bash
podman save -m --format docker-archive \
  -o /home/student/workspace/02-15/stack-bundle.tar \
  localhost/bundle-web:1.0 localhost/bundle-api:1.0

podman rmi localhost/bundle-web:1.0 localhost/bundle-api:1.0
podman load -i /home/student/workspace/02-15/stack-bundle.tar
```

## Explanation
`podman save -m` deduplicates shared base layers inside `stack-bundle.tar` while recording all RepoTags in `manifest.json`.

## Common Mistakes
- Running `podman save` with multiple image names without `-m`, which fails with `multi-image-archive must be set`.
