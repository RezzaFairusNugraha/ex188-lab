# Task 02-05: Authenticating to a Protected TLS Registry (:5444) and Custom --authfile

## Scenario
Production registry `auth-reg.lab.local:5444` requires **both** TLS trust (`/opt/ex188-lab/certs/ca.crt`) and HTTP Basic credentials (`ci-bot` / `Ex188Pass!`). Furthermore, automated Quadlet services read persistent credentials from `~/.config/containers/auth.json` (whereas ephemeral `XDG_RUNTIME_DIR/containers/auth.json` is wiped on reboot!).

## Requirements
1. Install `/opt/ex188-lab/certs/ca.crt` into `/etc/containers/certs.d/auth-reg.lab.local:5444/ca.crt` (mode `0644`).
2. Authenticate to `auth-reg.lab.local:5444` as user `ci-bot` (password `Ex188Pass!`) storing the persistent credential file at `/home/student/.config/containers/auth.json` (`--authfile`).
3. Push `registry.access.redhat.com/ubi10/ubi-minimal:latest` to `auth-reg.lab.local:5444/prod/core-ubi:1.0` using `--authfile /home/student/.config/containers/auth.json`.

> *Note*: Because official `registry.access.redhat.com/ubi10/*` images carry Red Hat GPG signatures, pass `--remove-signatures` on `podman push` when re-pushing a signed Red Hat image to a private registry.
