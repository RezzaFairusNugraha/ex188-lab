# Task 02-10: Pulling and Deploying an Image Strictly by SHA256 Digest

## Objective
Setup pushed two different images to `registry.lab.local:5000/sec/audit-runner`: first tag `:v1` (good), and later overwrote `:latest` with a decoy image! You must retrieve the exact manifest digest of `:v1`, pull by `@sha256:...`, and launch a container from that digest reference.

## Specification
1. Determine the `sha256:...` manifest digest of `registry.lab.local:5000/sec/audit-runner:v1` (`--tls-verify=false` allowed).
2. Write `registry.lab.local:5000/sec/audit-runner@sha256:<hex>` into `/home/student/workspace/02-10/pinned-ref.txt`.
3. Launch detached container `digest-runner` directly from that `registry.lab.local:5000/sec/audit-runner@sha256:...` reference running `sleep 3600`.
