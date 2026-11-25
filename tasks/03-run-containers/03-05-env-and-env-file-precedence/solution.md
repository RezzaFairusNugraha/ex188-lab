## Solution
```bash
podman run -d --name env-precedence -p 8305:8080 \
  --env-file /home/student/workspace/03-05/base.env \
  -e APP_ENV=production \
  localhost/webapp-envtest:1.0
```

## Explanation
Podman evaluates environment variables in strict order: `Containerfile ENV` < `--env-file` < `-e` / `--env`.

## Common Mistakes
- Editing `base.env` directly when the scenario forbids altering shared base config files.
