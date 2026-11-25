# Task 05-04: Resolving a Host TCP Port Conflict Blocking Service Startup

## Scenario
Created container `prod-portal-0504` (`PublishPort` `8504:8080`) fails whenever `podman start prod-portal-0504` is run (`address already in use`). Identify what rogue container or process is squatting on TCP port `8504`, remove ONLY the rogue squatter, and start `prod-portal-0504` on port `8504`!

## Requirements
1. Do **not** change `prod-portal-0504`'s port mapping (`8504 -> 8080`), and do **not** stop unrelated container `legit-neighbor-0504` (`8599 -> 8080`).
2. Identify and remove the squatter occupying host port `8504`, then start `prod-portal-0504` and verify `http://127.0.0.1:8504/` responds `200 OK`.
