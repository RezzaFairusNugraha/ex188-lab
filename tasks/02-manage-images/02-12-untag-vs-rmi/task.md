# Task 02-12: Untagging vs Deleting Underlying Image Storage (podman untag vs rmi)

## Scenario
Setup created two distinct custom images:
- Image A (`localhost/keep-layers:1.0` and `localhost/keep-layers:temp`) — you must strip **all** names from Image A using `podman untag` so its image ID **still exists** in local storage as `<none>:<none>` (and save its 12+ char Image ID to `/home/student/workspace/02-12/kept-id.txt`).
- Image B (`localhost/purge-completely:1.0`) — you must completely delete Image B and its layer from local storage using `podman rmi`.

## Requirements
1. Record the Image ID (`{{.Id}}`) of `localhost/keep-layers:1.0` into `/home/student/workspace/02-12/kept-id.txt`.
2. Remove **both** tags (`localhost/keep-layers:1.0` and `localhost/keep-layers:temp`) using `podman untag` so the underlying Image ID still exists in `podman images -a`!
3. Completely delete `localhost/purge-completely:1.0` using `podman rmi` so its Image ID no longer exists in local storage.
