## Solution
```bash
printf 'repo-credential.txt\n' > /home/student/workspace/01-20/.containerignore
cat > /home/student/workspace/01-20/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
RUN --mount=type=secret,id=repo_cred \
    sha256sum /run/secrets/repo_cred | awk '{print $1}' > /etc/cred-fingerprint
USER 1001
EOF

podman build \
  --secret id=repo_cred,src=/home/student/workspace/01-20/repo-credential.txt \
  -t localhost/secret-safe:1.0 /home/student/workspace/01-20
```

## Explanation
`RUN --mount=type=secret,id=repo_cred` mounts the secret on tmpfs at `/run/secrets/repo_cred` strictly for the duration of that `RUN` step; it is unmounted before the layer is committed and never recorded in `podman history`.

## Common Mistakes
- Passing `--build-arg TOKEN=$(cat repo-credential.txt)` — anyone running `podman history --no-trunc` or `podman image inspect` can read `ARG` values in plain text!
