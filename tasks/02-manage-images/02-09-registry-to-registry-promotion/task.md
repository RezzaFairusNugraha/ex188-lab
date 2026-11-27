# Task 02-09: Registry-to-Registry Promotion via podman pull, tag, and push

## Objective
A candidate build `registry.lab.local:5000/staging/order-worker:rc4` passed integration tests in the dev HTTP registry (`:5000`) and must be promoted to the TLS QA registry (`secure-reg.lab.local:5443`) under `secure-reg.lab.local:5443/release/order-worker:1.4` (`:${REL_TAG}` if `--seed` is active).

## Specification
1. Ensure `/opt/ex188-lab/certs/ca.crt` is installed under `/etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt`.
2. Pull `registry.lab.local:5000/staging/order-worker:rc4` (`--tls-verify=false` allowed on `:5000` only).
3. Tag the image as `secure-reg.lab.local:5443/release/order-worker:1.4` (`:${REL_TAG}`) and push it to `secure-reg.lab.local:5443` with TLS verification enabled.
4. Clean up the temporary `:rc4` local tag (`podman untag` or `podman rmi` of the staging tag) while keeping `secure-reg.lab.local:5443/release/order-worker:1.4` locally and remotely.
