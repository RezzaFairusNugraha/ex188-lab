## Solution
```bash
printf '*.secret\n' > /home/student/workspace/01-25/.containerignore
cat > /home/student/workspace/01-25/Containerfile <<'EOF'
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

podman build -t localhost/metrics-secure:2.0 /home/student/workspace/01-25
podman secret create metrics_scrape_tok /home/student/workspace/01-25/scrape-token.secret
podman run -d --name metrics-prod -p 9125:9090 \
  --secret metrics_scrape_tok,target=/run/secrets/scrape_token \
  localhost/metrics-secure:2.0
```

## Explanation
Copying `/src` from Stage 1 into Stage 2 defeats both the size reduction and secret-isolation benefits of multi-stage builds. Only compiled artifacts belong in `COPY --from=...`.

## Common Mistakes
- Leaving `COPY --from=buildstage /src /app` in place alongside `/usr/local/bin/metrics-agent`.
