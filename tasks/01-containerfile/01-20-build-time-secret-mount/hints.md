## Level 1 — Nudge
Check `man containerfile` for `RUN --mount=type=secret` and `man podman-build` for `--secret`. Also add `repo-credential.txt` to `.containerignore` for defense in depth!

## Level 2 — Approach
Write `RUN --mount=type=secret,id=repo_cred sha256sum /run/secrets/repo_cred | awk '{print $1}' > /etc/cred-fingerprint` in `Containerfile`, set `USER 1001`, and run `podman build --secret id=repo_cred,src=~/workspace/01-20/repo-credential.txt -t localhost/secret-safe:1.0 ~/workspace/01-20`.

## Level 3 — Key Commands
```bash
echo 'repo-credential.txt' > ~/workspace/01-20/.containerignore
cat > ~/workspace/01-20/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
RUN --mount=type=secret,id=repo_cred \
    sha256sum /run/secrets/repo_cred | awk '{print $1}' > /etc/cred-fingerprint
USER 1001
EOF
podman build --secret id=repo_cred,src=/home/student/workspace/01-20/repo-credential.txt \
  -t localhost/secret-safe:1.0 ~/workspace/01-20
```
