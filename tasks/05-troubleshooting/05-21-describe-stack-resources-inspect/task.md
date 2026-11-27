# Task 05-21: Describing Live Stack Resources with pod, volume, network, secret, and container inspect

## Objective
Before modifying or migrating an unfamiliar running multi-container application (`audit-pod-0521`), an architect audits all five Podman resource types (`pod`, `network`, `volume`, `secret`, `container`) using `podman <object> inspect --format` Go templates!

## Specification
Inspect the live resources deployed by setup and create `/home/student/workspace/05-21/resource-inventory.env` containing these five exact unquoted `KEY=VALUE` lines:
1. `POD_INFRA_ID=<full InfraContainerID of pod audit-pod-0521>`
2. `NET_SUBNET=<IPv4 CIDR subnet string of network audit-net-0521, e.g. 10.89.91.0/24>`
3. `VOL_MOUNTPOINT=<host Mountpoint path of volume audit-vol-0521>`
4. `SECRET_ID=<ID of Podman secret audit-sec-0521>`
5. `APP_USER=<Config.User of container audit-worker-0521>`
