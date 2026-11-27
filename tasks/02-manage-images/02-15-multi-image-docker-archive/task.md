# Task 02-15: Bundling Multiple Images into One Tarball with podman save -m

## Objective
When transferring multiple distinct images inside a single `.tar` file, `podman save --multi-image-archive` (`-m`) with `docker-archive` format preserves every repository:tag reference inside one bundle.

## Specification
1. Bundle both pre-staged images `localhost/bundle-web:1.0` and `localhost/bundle-api:1.0` into a single archive `/home/student/workspace/02-15/stack-bundle.tar` using `podman save -m --format docker-archive`.
2. Delete both `localhost/bundle-web:1.0` and `localhost/bundle-api:1.0` from local storage, then load `/home/student/workspace/02-15/stack-bundle.tar` back with `podman load` and verify both tags are restored.
