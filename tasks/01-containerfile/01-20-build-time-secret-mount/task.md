# Task 01-20: Mounting Ephemeral Build-Time Secrets Without Layer Leakage

## Objective
A build credential file has been placed at `/home/student/workspace/01-20/repo-credential.txt`. Build an image that consumes this credential during `podman build` to generate a SHA-256 fingerprint without leaving the raw secret in image layers or `podman history`.

## Specification
As user `student`:
1. Create `/home/student/workspace/01-20/Containerfile` on `registry.access.redhat.com/ubi10/ubi-minimal:latest`.
2. During `RUN`, mount build secret ID `repo_cred` (`--mount=type=secret,id=repo_cred`), compute the SHA-256 hex digest of `/run/secrets/repo_cred`, and write **only** the 64-character hex digest to `/etc/cred-fingerprint`.
3. Configure `USER 1001` and build `localhost/secret-safe:1.0` supplying `/home/student/workspace/01-20/repo-credential.txt` as secret `repo_cred`.
