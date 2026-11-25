## Solution
```bash
sudo mkdir -p /etc/containers/certs.d/secure-reg.lab.local:5443
sudo install -m 0644 /opt/ex188-lab/certs/ca.crt /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt

podman pull --tls-verify=false registry.lab.local:5000/staging/order-worker:rc4
podman tag registry.lab.local:5000/staging/order-worker:rc4 secure-reg.lab.local:5443/release/order-worker:1.4
podman push secure-reg.lab.local:5443/release/order-worker:1.4
podman rmi registry.lab.local:5000/staging/order-worker:rc4
```

> *Optional bonus alternative*: In CI pipelines where `skopeo` is installed, `skopeo copy --src-tls-verify=false --dest-cert-dir=... docker://... docker://...` can copy directly without local storage.

## Explanation
When an image ID has two tags (`staging/...:rc4` and `release/...:1.4`), `podman rmi <first-tag>` only removes that tag reference without deleting the shared underlying layers!

## Common Mistakes
- Passing `podman rmi -f <IMAGE_ID>`, which deletes **all** tags pointing to that image ID!
