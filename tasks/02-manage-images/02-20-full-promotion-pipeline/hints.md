## Level 1 — Nudge
Configure `70-dev.conf`, both `certs.d` directories, and `~/.config/containers/auth.json` first — once configured, every `podman pull` and `podman push` works cleanly without `--tls-verify=false`!

## Level 2 — Approach
1. Create `/etc/containers/registries.conf.d/70-dev.conf` (`insecure = true` for `registry.lab.local:5000`).
2. Install `/opt/ex188-lab/certs/ca.crt` into both `:5443` and `:5444` directories under `/etc/containers/certs.d/`.
3. Log in with `--authfile ~/.config/containers/auth.json`, pull from `:5000`, tag and push to `:5443` and `:5444`, then query `/v2/prod/payment-svc/tags/list` with `curl`.

## Level 3 — Key Commands
```bash
sudo tee /etc/containers/registries.conf.d/70-dev.conf >/dev/null <<'EOF'
[[registry]]
location = "registry.lab.local:5000"
insecure = true
EOF

for h in secure-reg.lab.local:5443 auth-reg.lab.local:5444; do
  sudo mkdir -p "/etc/containers/certs.d/${h}"
  sudo install -m 0644 /opt/ex188-lab/certs/ca.crt "/etc/containers/certs.d/${h}/ca.crt"
done

mkdir -p ~/.config/containers
podman login --authfile ~/.config/containers/auth.json -u student -p redhat123 auth-reg.lab.local:5444

podman pull registry.lab.local:5000/dev/payment-svc:0.9-rc2
podman tag registry.lab.local:5000/dev/payment-svc:0.9-rc2 \
  secure-reg.lab.local:5443/qa/payment-svc:1.0.0 \
  auth-reg.lab.local:5444/prod/payment-svc:1.0.0 \
  auth-reg.lab.local:5444/prod/payment-svc:latest

podman push secure-reg.lab.local:5443/qa/payment-svc:1.0.0
podman push --authfile ~/.config/containers/auth.json auth-reg.lab.local:5444/prod/payment-svc:1.0.0
podman push --authfile ~/.config/containers/auth.json auth-reg.lab.local:5444/prod/payment-svc:latest

curl -fsS --cacert /opt/ex188-lab/certs/ca.crt -u student:redhat123 \
  https://auth-reg.lab.local:5444/v2/prod/payment-svc/tags/list \
  -o ~/workspace/02-20/prod-tags.json
```
