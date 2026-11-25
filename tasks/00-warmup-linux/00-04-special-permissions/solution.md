## Solution
```bash
sudo groupadd -g 2460 devshare 2>/dev/null || true
sudo mkdir -p /srv/ex188-00-04/collab /srv/ex188-00-04/dropoff
sudo chown root:devshare /srv/ex188-00-04/collab
sudo chmod 2775 /srv/ex188-00-04/collab
sudo chown root:root /srv/ex188-00-04/dropoff
sudo chmod 1777 /srv/ex188-00-04/dropoff
sudo touch /srv/ex188-00-04/collab/ready.txt
```

## Explanation
On Linux directories, `setgid` (`2xxx`, shown as `s` in group execute) causes newly created files and subdirectories to inherit the parent directory's GID — the same mechanism used when preparing group-writable volumes for arbitrary-UID containers.

## Common Mistakes
- Running `chown` *after* `chmod 2775`, which can strip special permission bits depending on invocation.
- Confusing `4xxx` (`setuid`) with `2xxx` (`setgid`).
