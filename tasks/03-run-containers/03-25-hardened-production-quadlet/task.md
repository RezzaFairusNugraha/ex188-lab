# Task 03-25: Hardened Production Quadlet: Digest Pull, ReadOnly, DropCapability, and Firewall

## Scenario
Deploy `metrics-go` (already pushed by setup to `secure-reg.lab.local:5443/prod/metrics-agent:1.0`) as a fully hardened, reboot-persistent rootless Quadlet service!

## Requirements
1. Trust `/opt/ex188-lab/certs/ca.crt` for `secure-reg.lab.local:5443` under `/etc/containers/certs.d/` and look up the `@sha256:...` digest of `secure-reg.lab.local:5443/prod/metrics-agent:1.0`.
2. Create `~/.config/containers/systemd/prod-metrics.container`:
   - `Image=secure-reg.lab.local:5443/prod/metrics-agent@sha256:...` (pinned by digest!)
   - `ContainerName=prod-metrics`
   - `PublishPort=9325:9090`
   - `Environment=SERVICE_NAME=prod-node-01`
   - `ReadOnly=true`
   - `Tmpfs=/tmp:rw,noexec,nosuid,size=32m`
   - `DropCapability=ALL`
   - `NoNewPrivileges=true`
   - `[Service]` `Restart=always`, `[Install]` `WantedBy=default.target`
3. Start `prod-metrics.service`, enable lingering for `student`, and permanently open `9325/tcp` in `firewalld`.
