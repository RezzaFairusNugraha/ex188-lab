# Task 05-10: Fixing x509 Unknown Authority Error Caused by Misnamed /etc/containers/certs.d Path

## Scenario
An admin placed `ca.crt` into `/etc/containers/certs.d/secure-reg.lab.local/ca.crt`, yet `podman pull secure-reg.lab.local:5443/ops/agent-0510:1.0` fails with `tls: failed to verify certificate: x509: certificate signed by unknown authority`!

## Requirements
1. Do **not** disable TLS verification (`--tls-verify=false` and `insecure = true` are forbidden!).
2. Fix the `/etc/containers/certs.d/` directory layout so `podman pull --tls-verify=true secure-reg.lab.local:5443/ops/agent-0510:1.0` succeeds, and run detached container `agent-0510` (`sleep 3600`) from that pulled image.
