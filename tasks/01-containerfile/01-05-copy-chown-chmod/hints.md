## Level 1 — Nudge
`COPY` supports `--chown=<uid>:<gid>` and `--chmod=<octal>` flags directly on the instruction line.

## Level 2 — Approach
Set `WORKDIR /opt/app`, add two `COPY --chown=1001:1001 --chmod=...` instructions for `launcher.sh` (`0755`) and `settings.ini` (`0640`), declare `USER 1001` and `CMD ["/opt/app/launcher.sh"]`, and build `localhost/chown-demo:1.0`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/01-05/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
WORKDIR /opt/app
COPY --chown=1001:1001 --chmod=0755 launcher.sh /opt/app/launcher.sh
COPY --chown=1001:1001 --chmod=0640 settings.ini /opt/app/settings.ini
USER 1001
CMD ["/opt/app/launcher.sh"]
EOF
podman build -t localhost/chown-demo:1.0 ~/workspace/01-05
```
