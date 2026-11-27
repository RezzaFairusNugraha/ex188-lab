# Task 02-04: Trusting a Private TLS Registry CA Under /etc/containers/certs.d (:5443)

## Objective
Registry `secure-reg.lab.local:5443` uses HTTPS signed by the private Root CA at `/opt/ex188-lab/certs/ca.crt`. Disabling TLS verification (`insecure = true` or `--tls-verify=false`) is **prohibited** by security policy.

## Specification
1. Install `/opt/ex188-lab/certs/ca.crt` into the exact per-registry certificate directory `/etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt` so Podman trusts `secure-reg.lab.local:5443` with full TLS verification enabled.
2. Do **not** set `insecure = true` for `secure-reg.lab.local:5443`.
3. Tag `registry.access.redhat.com/ubi10/ubi-minimal:latest` as `secure-reg.lab.local:5443/qa/verified-ubi:1.0` and push it **with default TLS verification enabled**.

> *Note*: Because official `registry.access.redhat.com/ubi10/*` images carry Red Hat GPG signatures, pass `--remove-signatures` on `podman push` when re-pushing a signed Red Hat image to a private registry.
