# Task 00-05: Shell Profile Variables and Podman Env-File Sanitation

## Scenario
Developers handed you a shell script `/home/student/workspace/00-05/legacy-vars.sh` containing `export` keywords and quoted strings. Remember that `podman run --env-file` treats quotes literally as part of the value and rejects `export KEY=VALUE` syntax!

## Requirements
1. Create `~/.bashrc.d/ex188-profile.sh` so new Bash shells for `student` automatically export `EX188_SITE=dc-west` (or `TARGET_SITE` if `--seed` is active).
2. Convert `/home/student/workspace/00-05/legacy-vars.sh` into a clean Podman-compatible environment file at `/home/student/workspace/00-05/container.env`:
   - Strip leading `export ` prefixes.
   - Strip surrounding single or double quotes around values.
   - Omit blank lines and `#` comment lines.
   - Preserve all 4 key-value pairs (`APP_PORT`, `APP_ENV`, `LOG_LEVEL`, `CACHE_TTL`).
