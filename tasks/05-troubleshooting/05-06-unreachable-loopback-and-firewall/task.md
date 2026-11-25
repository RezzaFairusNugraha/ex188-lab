# Task 05-06: Fixing External Unreachability: Loopback Binding + App Bind Address + firewalld

## Scenario
An operator complains that `webapp-ext-0506` cannot be reached from external hosts on port `8506`. There are **three** layered networking mistakes:
1. Inside the container, `APP_BIND=127.0.0.1` restricts Flask to container loopback!
2. On `podman run`, `-p 127.0.0.1:8506:8080` restricts the host listener to host loopback!
3. Host `firewalld` blocks `8506/tcp`!

## Requirements
Fix all three layers so `webapp-ext-0506` (`localhost/ts-web-0506:1.0`) listens on `0.0.0.0:8080` inside the container, publishes `0.0.0.0:8506->8080` on the host, permanently opens `8506/tcp` in `firewalld`, and serves `http://127.0.0.1:8506/healthz` (`200 OK`).
