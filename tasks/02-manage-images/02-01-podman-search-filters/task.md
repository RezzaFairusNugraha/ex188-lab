# Task 02-01: Searching Container Registries with podman search Filters and Custom Format

## Objective
Setup seeded three repositories into your local registry `registry.lab.local:5000` (`ops/httpd-edge`, `ops/redis-cache`, `ops/metrics-collector`). You must query that registry using `podman search` with custom Go-template formatting.

## Specification
1. Search `registry.lab.local:5000/ops` using `podman search` (`--tls-verify=false` allowed on `:5000`) with `--format "{{.Name}}"` so only full repository names are printed (no column headers).
2. Save the sorted list of matching repository names to `/home/student/workspace/02-01/repos.txt`.
