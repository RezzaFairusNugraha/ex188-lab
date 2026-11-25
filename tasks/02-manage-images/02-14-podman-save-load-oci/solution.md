## Solution
```bash
podman save --format oci-archive \
  -o /home/student/workspace/02-14/backup-demo-oci.tar \
  localhost/backup-demo:1.0

podman rmi localhost/backup-demo:1.0
podman load -i /home/student/workspace/02-14/backup-demo-oci.tar
```

## Explanation
`oci-archive` stores an OCI Image Layout (`oci-layout`, `index.json`, `blobs/sha256/...`) inside a tarball, preserving full layer history and runtime config (`USER`, `ENV`, `CMD`).

## Common Mistakes
- Omitting `--format oci-archive`, which produces a `docker-archive` (`manifest.json`) tarball instead of an OCI layout archive.
