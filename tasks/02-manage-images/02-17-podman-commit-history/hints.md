## Level 1 — Nudge
Use `podman exec` to append `PATCH_VERIFIED=yes` to `/etc/hotfix.conf`, then check `man podman-commit` for `--author` and `--change`.

## Level 2 — Approach
Run `podman exec hotfix-sandbox sh -c 'echo PATCH_VERIFIED=yes >> /etc/hotfix.conf'` followed by `podman commit --author "student@lab.local" --change 'ENV HOTFIX_APPLIED=1.1' hotfix-sandbox localhost/hotfix-snapshot:1.1`.

## Level 3 — Key Commands
```bash
podman exec hotfix-sandbox sh -c 'echo PATCH_VERIFIED=yes >> /etc/hotfix.conf'
podman commit \
  --author "student@lab.local" \
  --change 'ENV HOTFIX_APPLIED=1.1' \
  hotfix-sandbox localhost/hotfix-snapshot:1.1
```
