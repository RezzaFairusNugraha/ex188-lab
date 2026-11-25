## Level 1 — Nudge
Pull the image with `--tls-verify=false` and inspect `.Digest` via `podman image inspect`, then use `FROM <repo>@<digest>` syntax.

## Level 2 — Approach
1. Pull `registry.lab.local:5000/base/ubi-pinned:stable` with `--tls-verify=false`.
2. Run `podman image inspect --format '{{.Digest}}'` on that image and write the output to `digest.txt`.
3. Write `FROM registry.lab.local:5000/base/ubi-pinned@<digest>` in `Containerfile`, write `pinned-build` to `/etc/release-channel`, and build with `podman build --tls-verify=false -t localhost/pinned-app:1.0`.

## Level 3 — Key Commands
```bash
podman pull --tls-verify=false registry.lab.local:5000/base/ubi-pinned:stable
DIG=$(podman image inspect --format '{{.Digest}}' registry.lab.local:5000/base/ubi-pinned:stable)
echo "$DIG" > ~/workspace/01-02/digest.txt
cat > ~/workspace/01-02/Containerfile <<EOF
FROM registry.lab.local:5000/base/ubi-pinned@${DIG}
RUN echo "pinned-build" > /etc/release-channel
EOF
podman build --tls-verify=false -t localhost/pinned-app:1.0 ~/workspace/01-02
```
