## Level 1 — Nudge
Check every defect systematically: single `RUN` + `dnf clean all`, `WORKDIR /opt/webapp`, `COPY --chown=1001:0`, delete `ENV APP_SECRET`, set `USER 1001`, use JSON exec `CMD`, and supply the secret at runtime with `podman secret`.

## Level 2 — Approach
Rewrite `~/workspace/01-24/Containerfile` cleanly, build `localhost/webapp-remediated:2.0`, create `remediated_secret`, and run `webapp-clean` mounting `--secret remediated_secret,target=/run/secrets/webapp_secret`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/01-24/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 \
    && mkdir -p /opt/webapp /var/lib/webapp/data \
    && chown -R 1001:0 /opt/webapp /var/lib/webapp \
    && chmod -R g=u /var/lib/webapp \
    && dnf clean all
WORKDIR /opt/webapp
COPY --chown=1001:0 app.py requirements.txt /opt/webapp/
ENV APP_PORT=8080
EXPOSE 8080
USER 1001
CMD ["python3", "/opt/webapp/app.py"]
EOF
podman build -t localhost/webapp-remediated:2.0 ~/workspace/01-24
printf 'SafeRuntimeSecret77' | podman secret create remediated_secret -
podman run -d --name webapp-clean -p 8124:8080 \
  -e APP_ENV=production -e REQUIRE_SECRET=1 \
  --secret remediated_secret,target=/run/secrets/webapp_secret \
  localhost/webapp-remediated:2.0
```
