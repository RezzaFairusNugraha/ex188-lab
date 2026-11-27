# Task 01-03: Building on ubi10-minimal with microdnf Single-Layer Hygiene

## Objective
Standard `ubi10/ubi` ships Python and full `dnf`, which increases attack surface for small CLI utilities. Red Hat `ubi10/ubi-minimal` replaces `dnf` with `microdnf` for compact footprints.

## Specification
1. Create `/home/student/workspace/01-03/Containerfile` starting from `registry.access.redhat.com/ubi10/ubi-minimal:latest`.
2. In a **single** `RUN` instruction, install `tar` and `gzip` using `microdnf` (`--nodocs`) and run `microdnf clean all` in the same layer so `/var/cache/yum` / `/var/cache/dnf` do not retain downloaded RPMs.
3. Configure the image to run as numeric UID `1001` and set default `CMD` in exec form to `["/usr/bin/tar", "--version"]`.
4. Build the image as `localhost/minimal-archiver:1.0`.
