## Level 1 — Nudge
Check `~/apps/webapp-flask/README.md` Section 3 for the exact environment variable names (`REDIS_HOST`, `DB_HOST`, `APP_SECRET_FILE`, `CHECK_STORAGE`).

## Level 2 — Approach
Build `localhost/acme-full:1.0` with `/var/lib/webapp/data` owned by `1001:0` (`g=u`). Create `readme-net`, both volumes, and `acme_sign_key`. Start `acme-redis` and `acme-pg` first, then start `acme-app` mounting `--secret acme_sign_key,target=/run/secrets/webapp_secret,uid=1001,mode=0400`.

## Level 3 — Key Commands
```bash
cp -r ~/apps/webapp-flask/. ~/workspace/04-17/build/
cat > ~/workspace/04-17/build/Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 && mkdir -p /opt/webapp /var/lib/webapp/data && chown -R 1001:0 /opt/webapp /var/lib/webapp && chmod -R g=u /var/lib/webapp && dnf clean all
COPY --chown=1001:0 app.py requirements.txt /opt/webapp/
USER 1001
CMD ["python3", "/opt/webapp/app.py"]
EOF
podman build -t localhost/acme-full:1.0 ~/workspace/04-17/build

podman network create readme-net
podman volume create acme-notes-vol
podman volume create acme-db-vol
printf 'SignKey_0417' | podman secret create acme_sign_key -

podman run -d --name acme-redis --network readme-net docker.io/library/redis:7-alpine
podman run -d --name acme-pg --network readme-net -v acme-db-vol:/var/lib/pgsql/data \
  -e POSTGRESQL_USER=u -e POSTGRESQL_PASSWORD=p -e POSTGRESQL_DATABASE=d \
  quay.io/sclorg/postgresql-16-c10s:latest
sleep 4

podman run -d --name acme-app --network readme-net -p 8417:8080 \
  -e APP_ENV=production -e REQUIRE_STRICT_ENV=1 -e REQUIRE_SECRET=1 -e CHECK_STORAGE=1 \
  -e REDIS_HOST=acme-redis -e DB_HOST=acme-pg \
  -v acme-notes-vol:/var/lib/webapp/data \
  --secret acme_sign_key,target=/run/secrets/webapp_secret,uid=1001,mode=0400 \
  localhost/acme-full:1.0
```
