## Solution
```bash
podman image inspect --format '{{.Id}}' localhost/keep-layers:1.0 > /home/student/workspace/02-12/kept-id.txt
podman untag localhost/keep-layers:1.0
podman rmi localhost/purge-completely:1.0
```

## Explanation
- `podman untag <image>` with no additional arguments strips **every** repository:tag name from that image ID, turning it into `<none>:<none>` without deleting its layers!
- `podman rmi <last-tag>` deletes both the tag and the underlying image layers.

## Common Mistakes
- Using `podman rmi` on both tags of `keep-layers`, which deletes Image A completely when the second tag is removed!
