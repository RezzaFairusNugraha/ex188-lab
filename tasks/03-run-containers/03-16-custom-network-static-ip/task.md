# Task 03-16: Creating a User-Defined Subnet Network and Assigning a Static Container IP

## Scenario
Podman v5 uses the **Netavark** network stack + **aardvark-dns** on RHEL 10, allowing rootless user-defined bridge networks with custom IPv4 CIDRs, gateways, and static container IPs.

## Requirements
1. Create a user-defined Podman network named `corp-net` with subnet `10.88.40.0/24` and gateway `10.88.40.1`.
2. Start detached container `static-node` from `registry.access.redhat.com/ubi10/ubi-minimal:latest` attached to `corp-net` with static IP address `10.88.40.55` running `sleep 3600`.
