## Solution
```bash
cp -r /home/student/apps/metrics-go/. /home/student/workspace/01-15/
cat > /home/student/workspace/01-15/Containerfile <<'EOF'
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

podman build -t localhost/metrics-go:1.0 /home/student/workspace/01-15
podman run -d --name metrics-agent -p 9190:9090 -e SERVICE_NAME=edge-telemetry localhost/metrics-go:1.0
```

## Explanation
Multi-stage builds discard every intermediate compiler layer from Stage 1, producing a ~35–40 MiB minimal UBI10 runtime image containing only the statically linked binary.

## Common Mistakes
- Omitting `CGO_ENABLED=0` when building on a glibc mismatch base, causing `no such file or directory` dynamic-linker errors in minimal/micro stages.
