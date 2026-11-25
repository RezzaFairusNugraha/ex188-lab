## Solution
```bash
podman container prune -f
podman image prune -f
podman system df > /home/student/workspace/01-22/system-df.txt
```

## Explanation
`podman image prune` removes only dangling (`<none>:<none>`) intermediate/orphaned images, whereas `podman image prune -a` removes **all** images not referenced by an existing container! Be careful on the exam not to wipe pre-staged images with `-a`.

## Common Mistakes
- Running `podman rm -fa` instead of `podman container prune -f`, killing active containers required by earlier exam tasks!
