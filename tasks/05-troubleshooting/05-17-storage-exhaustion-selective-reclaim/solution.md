## Solution
```bash
podman system df -v
podman container prune -f
podman volume prune -f
podman rmi localhost/bloated-junk:old
```

## Explanation
`podman system df -v` breaks down exact Reclaimable vs Unique bytes across Images, Containers (writable layers!), and Local Volumes — and `podman volume prune -f` safely skips any volume mounted by an existing container (`prod-keeper-vol`).

## Common Mistakes
- Running `podman system prune -a --volumes` blindly without checking whether a stopped container on another exam task was waiting to be started!
