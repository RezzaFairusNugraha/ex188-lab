# Task 05-19: Cleaning Stale Pod, Container, and Subnet Conflicts Blocking Stack Redeployment

## Objective
`/home/student/workspace/05-19/deploy-stack.sh` (which you must **not** edit!) tries to create network `orders-net` (`10.89.50.0/24`), pod `orders-pod` (`-p 8519:8080`), and containers `orders-cache` + `orders-web`. Right now it fails partway through due to three stale/conflicting objects left behind from a botched deployment (while unrelated container `do-not-touch-0519` must stay running!).

## Specification
1. Do **not** edit `/home/student/workspace/05-19/deploy-stack.sh` and do **not** stop `do-not-touch-0519`.
2. Inspect `podman pod ps -a`, `podman ps -a`, and `podman network ls` / `podman network inspect` to find and remove:
   - Any stale pod/containers occupying `orders-pod`, `orders-cache`, `orders-web`, or port `8519`.
   - The rogue unused network `stale-subnet-50` whose CIDR overlaps `10.89.50.0/24`!
3. Run `/home/student/workspace/05-19/deploy-stack.sh` cleanly to completion and verify `http://127.0.0.1:8519/healthz` returns `200 OK`!
