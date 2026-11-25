## Solution
```bash
podman run -d --name beacon-svc \
  --hostname beacon.lab.internal \
  --user 1005:1005 \
  registry.access.redhat.com/ubi10/ubi-minimal:latest sleep 3600

podman run --rm registry.access.redhat.com/ubi10/ubi-minimal:latest uname -r \
  > /home/student/workspace/03-01/kernel.txt
```

## Explanation
Notice `uname -r` inside the container returns the exact host RHEL 10 kernel version because containers share the host kernel!

## Common Mistakes
- Forgetting `--rm` on diagnostic test runs, leaving stopped containers behind.
