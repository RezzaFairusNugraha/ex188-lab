# Task 02-17: Capturing Live Container Modifications to a New Layer with podman commit

## Scenario
During an emergency hotfix investigation, an operator patched `/etc/hotfix.conf` inside running container `hotfix-sandbox`. You must snapshot that container's writable layer onto a new image `localhost/hotfix-snapshot:1.1` while preserving base layers and setting author/change metadata.

## Requirements
1. Inside running container `hotfix-sandbox`, append the line `PATCH_VERIFIED=yes` to `/etc/hotfix.conf` (note: content inside mounted volumes is **never** captured by `podman commit` — `/etc/hotfix.conf` is on the rootfs).
2. Commit `hotfix-sandbox` to `localhost/hotfix-snapshot:1.1` using `podman commit` with:
   - `--author "student@lab.local"`
   - `--change 'ENV HOTFIX_APPLIED=1.1'`
3. Verify `localhost/hotfix-snapshot:1.1` has **more** layers than the base image (`len .RootFS.Layers >= 2`) and retains `/etc/hotfix.conf` containing `PATCH_VERIFIED=yes`.
