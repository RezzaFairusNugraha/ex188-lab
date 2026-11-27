# Task 02-08: Remote Tag Listing and Manifest Inspection with Podman

## Objective
Setup pushed multiple version tags of `registry.lab.local:5000/catalog/billing-api` (`1.0`, `1.1`, `2.0-rc1`) to the HTTP registry `:5000`. Without pulling the image into local storage, you must list its remote tags and save the raw manifest JSON of tag `2.0-rc1` using Podman commands.

## Specification
1. Use `podman search --list-tags` (`--tls-verify=false`) against `registry.lab.local:5000/catalog/billing-api` and save the full command output to `/home/student/workspace/02-08/tags-output.txt`.
2. Use `podman manifest inspect` (`--tls-verify=false`) against `docker://registry.lab.local:5000/catalog/billing-api:2.0-rc1` (or bare `registry.lab.local:5000/catalog/billing-api:2.0-rc1`) and save the JSON manifest to `/home/student/workspace/02-08/manifest.json`.
3. Do **not** pull `registry.lab.local:5000/catalog/billing-api` into local `podman images` storage!
