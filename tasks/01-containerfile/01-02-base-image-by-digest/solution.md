## Solution
```bash
podman pull --tls-verify=false registry.lab.local:5000/base/ubi-pinned:stable
DIG="$(podman image inspect --format '{{.Digest}}' registry.lab.local:5000/base/ubi-pinned:stable)"
printf '%s\n' "${DIG}" > /home/student/workspace/01-02/digest.txt

cat > /home/student/workspace/01-02/Containerfile <<EOF
FROM registry.lab.local:5000/base/ubi-pinned@${DIG}
RUN printf 'pinned-build\n' > /etc/release-channel
EOF

podman build --tls-verify=false -t localhost/pinned-app:1.0 /home/student/workspace/01-02
```

> *Optional bonus alternative*: When `skopeo` happens to be available on an admin workstation, `skopeo inspect --tls-verify=false --format '{{.Digest}}' docker://registry.lab.local:5000/base/ubi-pinned:stable` can retrieve the digest without pulling layers first.

## Explanation
Referencing `repo@sha256:...` guarantees cryptographic immutability: even if `:stable` is re-tagged upstream, rebuilds always use the exact manifest digest.

## Common Mistakes
- Copying `.Id` (the uncompressed image config SHA) instead of `.Digest` (the registry manifest digest)! Always inspect `{{.Digest}}` or `{{.RepoDigests}}`.
