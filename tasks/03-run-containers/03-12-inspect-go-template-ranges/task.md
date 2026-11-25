# Task 03-12: Iterating Container Mounts, Env, and Labels with Go Template range and index

## Scenario
Using `podman inspect --format` Go templates (`range`, `index`, `println`) — without relying on `jq` — extract structured multi-item metadata from running container `complex-meta`.

## Requirements
1. Extract every mount on `complex-meta` formatted as `<Type>:<Destination>` (one per line, sorted) into `/home/student/workspace/03-12/mounts.txt`.
2. Extract the value of label `com.acme.cost-center` (notice the dots and hyphen in the label key!) from `complex-meta` into `/home/student/workspace/03-12/cost-center.txt`.
3. Extract every environment variable from `complex-meta` (one `KEY=VALUE` per line) and filter only lines starting with `FEATURE_` into `/home/student/workspace/03-12/features.env`.
