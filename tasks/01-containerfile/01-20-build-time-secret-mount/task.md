# Task 01-20: Eliminating Baked Secrets at Build Time with podman build --secret

## Scenario
Setup created `/home/student/workspace/01-20/repo-credential.txt` containing a private token. Passing it via `ARG` or `COPY` leaks the secret into `podman history` or image layers! Instead, mount it ephemerally during `RUN` using `RUN --mount=type=secret` and `podman build --secret`.

## Requirements
1. Author `/home/student/workspace/01-20/Containerfile` on `registry.access.redhat.com/ubi10/ubi-minimal:latest`.
2. During `RUN`, mount build secret `id=repo_cred` (`--mount=type=secret,id=repo_cred`), compute its SHA256 hash (`sha256sum /run/secrets/repo_cred | awk '{print $1}'`), and save **only the SHA256 hash** to `/etc/cred-fingerprint`.
3. Set `USER 1001` and build `localhost/secret-safe:1.0` passing `--secret id=repo_cred,src=/home/student/workspace/01-20/repo-credential.txt`.
4. Verify the raw secret value never appears in `podman history --no-trunc localhost/secret-safe:1.0` or anywhere in the image filesystem!
