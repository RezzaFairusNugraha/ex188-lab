## Solution
```bash
cat > /home/student/workspace/01-05/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
WORKDIR /opt/app
COPY --chown=1001:1001 --chmod=0755 launcher.sh /opt/app/launcher.sh
COPY --chown=1001:1001 --chmod=0640 settings.ini /opt/app/settings.ini
USER 1001
CMD ["/opt/app/launcher.sh"]
EOF

podman build -t localhost/chown-demo:1.0 /home/student/workspace/01-05
```

## Explanation
Remember that switching `USER 1001` in a `Containerfile` does **not** change the ownership of files copied afterward — `COPY` still defaults to `0:0` (`root:root`) unless `--chown` is explicitly specified!

## Common Mistakes
- Assuming `USER 1001` before `COPY` makes copied files owned by `1001` (it never does; `COPY` defaults to `root:root`).
