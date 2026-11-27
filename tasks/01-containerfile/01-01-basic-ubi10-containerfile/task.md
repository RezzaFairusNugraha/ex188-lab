# Task 01-01: Authoring a Clean UBI10 Containerfile with Pinned Base Tag

## Objective
Your team is standardizing base web images on Red Hat Universal Base Image 10 (`ubi10`). A static `index.html` file has been placed in `/home/student/workspace/01-01/`.

## Specification
As user `student`:
1. Create `/home/student/workspace/01-01/Containerfile` (never name it `Dockerfile`) using `registry.access.redhat.com/ubi10/ubi:latest` as the `FROM` base image.
2. Install `httpd` via `dnf` and clean package metadata in the same `RUN` instruction.
3. Copy `index.html` from the build context to `/var/www/html/index.html`.
4. Document TCP port `80` using `EXPOSE` and configure `CMD` in exec form to run `/usr/sbin/httpd -D FOREGROUND`.
5. Build the image tagged as `localhost/ubi10-httpd:1.0` (or `localhost/${IMAGE_NAME}:${IMAGE_TAG}` if `--seed` is active).
