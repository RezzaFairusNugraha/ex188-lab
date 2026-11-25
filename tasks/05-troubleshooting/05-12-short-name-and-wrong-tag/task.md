# Task 05-12: Fixing Deployment Failure Caused by Unqualified Short Name and Non-Existent Tag

## Scenario
Script `/home/student/workspace/05-12/deploy.sh` fails in non-interactive execution because it references short name `inventory/catalog-svc:v2.1` (ambiguous short name AND wrong tag prefix `v`!). Discover the real repository and tag inside `registry.lab.local:5000` using `podman search` and fix `deploy.sh`!

## Requirements
1. Query `registry.lab.local:5000` (`--tls-verify=false`) with `podman search` and `podman search --list-tags` to find the actual tag on `inventory/catalog-svc`.
2. Fix `/home/student/workspace/05-12/deploy.sh` to use the **Fully Qualified Image Name** and exact tag, then execute `deploy.sh` so container `catalog-svc` is running!
