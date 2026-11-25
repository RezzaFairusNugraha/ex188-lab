# Task 02-19: Offline Image Ingestion Using Podman oci-archive: and dir: Transports

## Scenario
Air-gapped media often delivers images either as an unpacked `dir:` directory (`manifest.json` + layer tarballs on disk) or as an `oci-archive:` tarball. Podman natively speaks container transports (`dir:`, `oci-archive:`, `docker-archive:`) directly in `podman pull` and `podman push`!

Setup placed:
- An unpacked `dir:` image layout at `/home/student/workspace/02-19/unpacked-dir`
- An OCI archive tarball at `/home/student/workspace/02-19/bundle-oci.tar`

## Requirements
Using `podman` commands only:
1. Ingest `/home/student/workspace/02-19/unpacked-dir` via the `dir:` transport (`podman pull dir:...`) and tag it locally as `localhost/from-dir:1.0`.
2. Ingest `/home/student/workspace/02-19/bundle-oci.tar` via `podman pull oci-archive:...` (or `podman load`) and ensure it is tagged locally as `localhost/from-oci:1.0`.
3. Export `localhost/from-dir:1.0` out to a new `dir:` directory `/home/student/workspace/02-19/exported-dir` using `podman push localhost/from-dir:1.0 dir:/home/student/workspace/02-19/exported-dir`.
