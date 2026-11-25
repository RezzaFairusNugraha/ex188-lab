## Solution
```bash
cat > /home/student/workspace/01-06/.containerignore <<'EOF'
.git
*.secret
*.log
*.bak
Containerfile
.containerignore
EOF

podman build -t localhost/clean-context:1.0 /home/student/workspace/01-06
```

## Explanation
Whenever a `Containerfile` uses `COPY . <dest>`, `.containerignore` prevents local secrets (`.env*`), `.git` history, build logs, and `Containerfile` itself from being baked permanently into image layers.

## Common Mistakes
- Deleting `.env.secret` in a subsequent `RUN rm` command — the secret still exists in the earlier `COPY` layer and can be extracted via `podman save`!
