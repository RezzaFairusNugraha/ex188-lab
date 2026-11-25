## Level 1 — Nudge
Name the first `FROM ... AS builder`, compile `/out/metrics-agent`, start a second `FROM registry.access.redhat.com/ubi10/ubi-minimal:latest`, and use `COPY --from=builder`.

## Level 2 — Approach
Read `~/apps/metrics-go/README.md` for the exact `CGO_ENABLED=0` build line. In Stage 2, copy `/out/metrics-agent` to `/usr/local/bin/metrics-agent`, set `USER 1001` and `ENTRYPOINT ["/usr/local/bin/metrics-agent"]`, build `localhost/metrics-go:1.0`, and run `metrics-agent` on `-p 9190:9090 -e SERVICE_NAME=edge-telemetry`.

## Level 3 — Key Commands
```bash
cp -r ~/apps/metrics-go/. ~/workspace/01-15/
cat > ~/workspace/01-15/Containerfile <<'EOF'
FROM docker.io/library/golang:1.22 AS builder
WORKDIR /src
COPY go.mod main.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/metrics-agent .

FROM registry.access.redhat.com/ubi10/ubi-minimal:latest
COPY --from=builder --chmod=0755 /out/metrics-agent /usr/local/bin/metrics-agent
EXPOSE 9090
USER 1001
ENTRYPOINT ["/usr/local/bin/metrics-agent"]
EOF
podman build -t localhost/metrics-go:1.0 ~/workspace/01-15
podman run -d --name metrics-agent -p 9190:9090 -e SERVICE_NAME=edge-telemetry localhost/metrics-go:1.0
```
