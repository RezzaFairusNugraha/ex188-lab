## Solution
```bash
podman diff drift-watch > /home/student/workspace/03-15/full-diff.txt
awk '$1 == "A" {print $2}' /home/student/workspace/03-15/full-diff.txt \
  | sort > /home/student/workspace/03-15/added-paths.txt
podman exec drift-watch rm -f /tmp/unauthorized-dropper.sh
```

## Explanation
`podman diff` compares the container's upper writable layer directly against the read-only image lower layers without needing to `exec` inside the container first.

## Common Mistakes
- Deleting `/tmp/unauthorized-dropper.sh` *before* capturing the initial forensic diff!
