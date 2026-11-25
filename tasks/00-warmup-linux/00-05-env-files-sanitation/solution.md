## Solution
```bash
mkdir -p ~/.bashrc.d
printf 'export EX188_SITE=dc-west\n' > ~/.bashrc.d/ex188-profile.sh

sed -E '/^[[:space:]]*(#|$)/d; s/^export //; s/["'\'']//g' \
  /home/student/workspace/00-05/legacy-vars.sh > /home/student/workspace/00-05/container.env
```

## Explanation
Unlike `source` in Bash, `podman run --env-file` does **not** strip quotes around `"8080"` — leaving quotes causes applications to fail parsing `"8080"` as an integer!

## Common Mistakes
- Leaving `"production"` quoted inside `.env` files passed to `podman run --env-file` or Quadlet `EnvironmentFile=`.
- Writing `EX188_SITE=dc-west` without `export` in `~/.bashrc.d/ex188-profile.sh`, preventing child processes from inheriting it.
