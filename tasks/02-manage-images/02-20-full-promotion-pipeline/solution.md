## Solution
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

mkdir -p /home/student/.config/containers
podman login \
  --authfile /home/student/.config/containers/auth.json \
  -u student -p redhat123 \
  auth-reg.lab.local:5444

podman pull registry.lab.local:5000/dev/payment-svc:0.9-rc2
podman tag registry.lab.local:5000/dev/payment-svc:0.9-rc2 \
  secure-reg.lab.local:5443/qa/payment-svc:1.0.0 \
  auth-reg.lab.local:5444/prod/payment-svc:1.0.0 \
  auth-reg.lab.local:5444/prod/payment-svc:latest

podman push secure-reg.lab.local:5443/qa/payment-svc:1.0.0
podman push --authfile /home/student/.config/containers/auth.json auth-reg.lab.local:5444/prod/payment-svc:1.0.0
podman push --authfile /home/student/.config/containers/auth.json auth-reg.lab.local:5444/prod/payment-svc:latest

curl -fsS --cacert /opt/ex188-lab/certs/ca.crt -u student:redhat123 \
  https://auth-reg.lab.local:5444/v2/prod/payment-svc/tags/list \
  -o /home/student/workspace/02-20/prod-tags.json
```

## Explanation
Setting up `registries.conf.d/`, `/etc/containers/certs.d/<host:port>/ca.crt`, and `~/.config/containers/auth.json` once at the start of an exam ensures every subsequent `podman pull`, `podman build`, and Quadlet `systemctl --user start` succeeds without ad-hoc TLS bypasses.

## Common Mistakes
- Forgetting to pass `--authfile ~/.config/containers/auth.json` on `podman push` if a stale `$XDG_RUNTIME_DIR/containers/auth.json` exists and shadows `~/.config/containers/auth.json`!
