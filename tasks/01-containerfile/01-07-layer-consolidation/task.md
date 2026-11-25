# Task 01-07: Consolidating RUN Layers and Cleaning DNF Metadata

## Scenario
`/home/student/workspace/01-07/Containerfile` currently uses five separate `RUN` layers, creates a temporary 50 MiB build artifact in one layer, and tries to delete it in a later layer — leaving 50 MiB of dead space plus `dnf` caches inside the image.

## Requirements
1. Refactor `/home/student/workspace/01-07/Containerfile` so all package installation (`python3`), temporary artifact processing (`/tmp/stage.bin` -> `/etc/app-checksum`), user setup, and cleanup (`dnf clean all && rm -rf /var/cache/dnf /tmp/stage.bin`) execute in **a single `RUN` instruction**.
2. Preserve `/etc/app-checksum` containing the SHA256 digest of the generated staging payload (`printf 'ex188-seed' | sha256sum | awk '{print $1}'`).
3. Build `localhost/lean-python:1.0` and verify its total image size is **at least 45 MiB smaller** than the unoptimized `localhost/bloated-python:legacy` image created by setup.
