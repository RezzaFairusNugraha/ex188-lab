## Solution
```bash
IMG_ID="$(podman pull -q dir:/home/student/workspace/02-19/unpacked-dir)"
podman tag "${IMG_ID}" localhost/from-dir:1.0

podman load -i /home/student/workspace/02-19/bundle-oci.tar

mkdir -p /home/student/workspace/02-19/exported-dir
podman push localhost/from-dir:1.0 dir:/home/student/workspace/02-19/exported-dir
```

> *Optional bonus alternative*: `skopeo copy dir:... containers-storage:localhost/from-dir:1.0` uses the exact same underlying `containers-transports(5)` syntax.

## Explanation
`podman load` only reads tar archives (`docker-archive` / `oci-archive`), whereas `podman pull dir:/path` and `podman push <img > dir:/path` read and write unpacked `dir:` image directories directly!

## Common Mistakes
- Passing a `dir:` directory to `podman load -i` (fails because `podman load` expects a `.tar` stream, whereas `podman pull dir:/path` handles directories).
