# Task 01-02: Pinning a Base Image by Immutable SHA256 Digest

## Scenario
Mutable tags like `:latest` or `:1.0` can be overwritten in a registry. Regulated workloads pin their `FROM` instruction to an exact `sha256` manifest digest. Setup has published `registry.lab.local:5000/base/ubi-pinned:stable` to the local HTTP registry (`registry.lab.local:5000`).

## Requirements
1. Inspect the manifest digest (`sha256:...`) of `registry.lab.local:5000/base/ubi-pinned:stable` using `podman` (`--tls-verify=false` may be used for this plain-HTTP dev registry).
2. Save **only** the `sha256:...` digest string to `/home/student/workspace/01-02/digest.txt`.
3. Create `/home/student/workspace/01-02/Containerfile` whose `FROM` line references `registry.lab.local:5000/base/ubi-pinned@sha256:...` (no `:stable` tag in `FROM`), adds `/etc/release-channel` containing `pinned-build`, and build it as `localhost/pinned-app:1.0`.
