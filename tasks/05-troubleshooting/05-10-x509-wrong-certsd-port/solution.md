## Solution
```bash
sudo mv /etc/containers/certs.d/secure-reg.lab.local /etc/containers/certs.d/secure-reg.lab.local:5443
sudo chmod 0644 /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt
podman run -d --name agent-0510 secure-reg.lab.local:5443/ops/agent-0510:1.0 sleep 3600
```

## Explanation
Notice there were **two** subtle traps in setup:
1. Missing `:5443` on `/etc/containers/certs.d/secure-reg.lab.local:5443`.
2. Mode `0600` (`-rw------- root root`) on `ca.crt`, which silently prevents rootless `student` from reading the CA certificate!

## Common Mistakes
- Renaming the folder to `:5443` while leaving `ca.crt` mode `0600`!
