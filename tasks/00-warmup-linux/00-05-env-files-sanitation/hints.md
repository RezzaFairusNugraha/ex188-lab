## Level 1 — Nudge
RHEL 10's default `~/.bashrc` sources every file in `~/.bashrc.d/*.sh`. Meanwhile, Podman `--env-file` expects bare `KEY=VALUE` lines without shell `export` or quotes.

## Level 2 — Approach
1. Write `export EX188_SITE=dc-west` into `~/.bashrc.d/ex188-profile.sh`.
2. Filter `legacy-vars.sh` with `grep -vE '^(#|$)'` and strip `^export ` plus `'` / `"` characters using `sed` (or edit cleanly in `vim`).

## Level 3 — Key Commands
```bash
mkdir -p ~/.bashrc.d
echo 'export EX188_SITE=dc-west' > ~/.bashrc.d/ex188-profile.sh
sed -E '/^[[:space:]]*(#|$)/d; s/^export //; s/["'\'']//g' \
  ~/workspace/00-05/legacy-vars.sh > ~/workspace/00-05/container.env
```
