# Task 02-03: Configuring Plain HTTP Registry Access in registries.conf.d (:5000)

## Scenario
Lab registry `registry.lab.local:5000` serves plain HTTP without TLS. Passing `--tls-verify=false` manually on every CLI command does not work inside Quadlet `.container` units unless the registry is marked `insecure = true` in `registries.conf.d`.

## Requirements
1. Create `/etc/containers/registries.conf.d/50-lab-http.conf` declaring a `[[registry]]` entry for `location = "registry.lab.local:5000"` with `insecure = true`.
2. Tag `registry.access.redhat.com/ubi10/ubi-minimal:latest` as `registry.lab.local:5000/dev/base-ubi:1.0` and push it **without** passing `--tls-verify=false` on the command line.
3. Remove the local tag `registry.lab.local:5000/dev/base-ubi:1.0` and pull it back cleanly without `--tls-verify=false`.

> *Note*: Because official `registry.access.redhat.com/ubi10/*` images carry Red Hat GPG signatures, pass `--remove-signatures` on `podman push` when re-pushing a signed Red Hat image to a private registry.
