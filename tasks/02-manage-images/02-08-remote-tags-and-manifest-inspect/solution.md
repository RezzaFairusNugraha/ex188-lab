## Solution
```bash
podman search --tls-verify=false --list-tags \
  registry.lab.local:5000/catalog/billing-api > /home/student/workspace/02-08/tags-output.txt

podman manifest inspect --tls-verify=false \
  docker://registry.lab.local:5000/catalog/billing-api:2.0-rc1 > /home/student/workspace/02-08/manifest.json
```

> *Optional bonus alternative*: Outside Podman-only environments, `skopeo list-tags` and `skopeo inspect --raw` can perform equivalent remote queries.

## Explanation
`podman search --list-tags <registry>/<repo>` queries `/v2/<repo>/tags/list`, while `podman manifest inspect docker://<ref>` fetches the remote OCI/Docker v2 manifest JSON without downloading image layers.

## Common Mistakes
- Running `podman pull` + `podman image inspect`, which downloads all image layers locally.
