## Solution
```bash
# Live fix without even restarting the container:
podman unshare chown -R 1001:1001 /home/student/workspace/05-08/journal
curl -fsS -X POST 'http://127.0.0.1:8508/entries?msg=uid-fixed'
```

## Explanation
Look how fast `podman unshare chown -R 1001:1001 <dir>` is when a running container already has `:Z` applied — it shifts directory ownership inside the rootless user namespace immediately with zero downtime!

## Common Mistakes
- Running `sudo chown 1001:1001` on the host! Host UID `1001` is unmapped (`nobody` / `65534`) inside `student`'s user namespace — `podman unshare chown 1001:1001` maps to subordinate host UID `101000`!
