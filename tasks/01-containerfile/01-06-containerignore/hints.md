## Level 1 — Nudge
Podman reads `.containerignore` in the root of the build context using glob rules before sending files to `COPY .`.

## Level 2 — Approach
Create `/home/student/workspace/01-06/.containerignore` listing `.git`, `*.secret`, `*.log`, `*.bak`, `Containerfile`, and `.containerignore`, then run `podman build -t localhost/clean-context:1.0`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/01-06/.containerignore <<'EOF'
.git
*.secret
*.log
*.bak
Containerfile
.containerignore
EOF
podman build -t localhost/clean-context:1.0 ~/workspace/01-06
```
