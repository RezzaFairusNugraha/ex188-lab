# Task 02-07: Configure a Registry Mirror with [[registry.mirror]] in registries.conf.d

## Objective
Disconnected environments rewrite image pull requests from an unreachable external registry (`upstream-hub.corp.example`) to an alternate internal mirror location (`secure-reg.lab.local:5443`) using `[[registry.mirror]]` in `registries.conf.d` (note: in Podman `registries.conf`, mirrors are alternate registry locations consulted before the primary `location`, not a pull-through proxy daemon).

Setup pre-loaded `secure-reg.lab.local:5443/platform/agent:2.1` inside the TLS registry `:5443`.

## Specification
1. Ensure CA `/opt/ex188-lab/certs/ca.crt` is trusted for `secure-reg.lab.local:5443` under `/etc/containers/certs.d/`.
2. Ensure no user-level `~/.config/containers/registries.conf` overrides system `registries.conf.d/`.
3. Create `/etc/containers/registries.conf.d/60-corp-mirror.conf` defining a `[[registry]]` table for `prefix = "upstream-hub.corp.example"` (`location = "upstream-hub.corp.example"`) with a nested `[[registry.mirror]]` pointing to `location = "secure-reg.lab.local:5443"`.
4. Verify `podman pull upstream-hub.corp.example/platform/agent:2.1` succeeds transparently via the mirror without modifying `Containerfile` or image references!
