## Level 1 — Nudge
Exclude `*.secret` in `.containerignore`, copy only the compiled `/out/metrics-agent` binary into Stage 2, set `USER 1001` and exec-form `ENTRYPOINT`, and mount the token via `podman secret create` + `--secret`.

## Level 2 — Approach
1. Write `*.secret` to `~/workspace/01-25/.containerignore`.
2. Fix Stage 1 (`CGO_ENABLED=0 GOOS=linux go build -o /out/metrics-agent .`) and Stage 2 (`COPY --from=buildstage --chmod=0755 /out/metrics-agent /usr/local/bin/metrics-agent`, `USER 1001`, `ENTRYPOINT ["/usr/local/bin/metrics-agent"]`).
3. Build `localhost/metrics-secure:2.0`, create secret `metrics_scrape_tok`, and start `metrics-prod`.

## Level 3 — Key Commands
```bash
printf '*.secret\n' > ~/workspace/01-25/.containerignore
cat > ~/workspace/01-25/Containerfile <<'EOF'
FROM docker.io/library/golang:1.22 AS buildstage
WORKDIR /src
COPY go.mod main.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/metrics-agent .

FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
COPY --from=buildstage --chmod=0755 /out/metrics-agent /usr/local/bin/metrics-agent
EXPOSE 9090
USER 1001
ENTRYPOINT ["/usr/local/bin/metrics-agent"]
EOF
podman build -t localhost/metrics-secure:2.0 ~/workspace/01-25
tr -d '\r\n' < ~/workspace/01-25/scrape-token.secret | podman secret create metrics_scrape_tok -
podman run -d --name metrics-prod -p 9125:9090 \
  --secret metrics_scrape_tok,target=/run/secrets/scrape_token \
  localhost/metrics-secure:2.0
```
