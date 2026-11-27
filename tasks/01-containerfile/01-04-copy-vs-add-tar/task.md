# Task 01-04: COPY vs ADD: Auto-Extracting Local Tarballs vs Copying Literal Archives

## Objective
`/home/student/workspace/01-04/` contains two tarballs:
- `site-assets.tar.gz` — contains `index.html` and `app.css` that must be **extracted** into `/usr/share/nginx/html/`.
- `release-backup.tar.gz` — must remain an **unextracted** `.tar.gz` file downloadable at `/usr/share/nginx/html/downloads/release-backup.tar.gz`.

## Specification
1. Author `/home/student/workspace/01-04/Containerfile` based on `quay.io/nginx/nginx-unprivileged:1.26-alpine`.
2. Use the appropriate `Containerfile` instruction so `site-assets.tar.gz` is automatically unpacked into `/usr/share/nginx/html/` without invoking `RUN tar`.
3. Use the appropriate `Containerfile` instruction so `release-backup.tar.gz` is copied intact (not unpacked) to `/usr/share/nginx/html/downloads/release-backup.tar.gz`.
4. Build the image as `localhost/portal-static:1.0`.
