## Solution
```bash
# Note: setup already pre-stages vendor files in the workspace directory
cp -r /home/student/apps/webapp-flask/. /home/student/workspace/04-17/build/
cat > /home/student/workspace/04-17/build/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 \
    && mkdir -p /opt/webapp /var/lib/webapp/data \
    && chown -R 1001:0 /opt/webapp /var/lib/webapp \
    && chmod -R g=u /var/lib/webapp \
    && dnf clean all
COPY --chown=1001:0 app.py requirements.txt /opt/webapp/
USER 1001
CMD ["python3", "/opt/webapp/app.py"]
EOF

podman build -t localhost/acme-full:1.0 /home/student/workspace/04-17/build

podman network create readme-net
podman volume create acme-notes-vol
podman volume create acme-db-vol
printf 'SignKey_0417' | podman secret create acme_sign_key -

podman run -d --name acme-redis --network readme-net docker.io/library/redis:7-alpine
podman run -d --name acme-pg --network readme-net \
  -v acme-db-vol:/var/lib/pgsql/data \
  -e POSTGRESQL_USER=u -e POSTGRESQL_PASSWORD=p -e POSTGRESQL_DATABASE=d \
  quay.io/sclorg/postgresql-16-c10s:latest
sleep 4

podman run -d --name acme-app --network readme-net -p 8417:8080 \
  -e APP_ENV=production \
  -e REQUIRE_STRICT_ENV=1 \
  -e REQUIRE_SECRET=1 \
  -e CHECK_STORAGE=1 \
  -e REDIS_HOST=acme-redis \
  -e DB_HOST=acme-pg \
  -v acme-notes-vol:/var/lib/webapp/data \
  --secret acme_sign_key,target=/run/secrets/webapp_secret,uid=1001,mode=0400 \
  localhost/acme-full:1.0
```

## Explanation
Reading the vendor `README.md` carefully before writing a single command prevents guessing wrong variable names (`POSTGRES_HOST` vs `DB_HOST`) under exam time pressure.

## Common Mistakes
- Mounting `acme_sign_key` without `target=/run/secrets/webapp_secret`, leaving the file at `/run/secrets/acme_sign_key` where `app.py` does not look by default!
