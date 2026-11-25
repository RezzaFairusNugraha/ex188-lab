## Level 1 — Nudge
Check **both** the directory name under `/etc/containers/certs.d/` (must include `:5443`!) AND the file permissions (`ls -l`) on `ca.crt` so rootless `student` can read it!

## Level 2 — Approach
Rename/move `/etc/containers/certs.d/secure-reg.lab.local` to `/etc/containers/certs.d/secure-reg.lab.local:5443`, `sudo chmod 0644 .../ca.crt`, pull the image, and start `agent-0510`.

## Level 3 — Key Commands
```bash
sudo mv /etc/containers/certs.d/secure-reg.lab.local /etc/containers/certs.d/secure-reg.lab.local:5443
sudo chmod 0644 /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt
podman run -d --name agent-0510 secure-reg.lab.local:5443/ops/agent-0510:1.0 sleep 3600
```
