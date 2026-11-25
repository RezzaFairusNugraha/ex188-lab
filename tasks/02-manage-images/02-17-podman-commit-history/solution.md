## Solution
```bash
podman exec hotfix-sandbox sh -c 'printf "PATCH_VERIFIED=yes\n" >> /etc/hotfix.conf'
podman commit \
  --author "student@lab.local" \
  --change 'ENV HOTFIX_APPLIED=1.1' \
  hotfix-sandbox localhost/hotfix-snapshot:1.1
```

## Explanation
`podman commit` turns the container's upper OverlayFS diff (`podman diff hotfix-sandbox`) into an additional layer on top of the parent image, preserving parent `ENV`, `CMD`, and history while skipping any mounted volumes.

## Common Mistakes
- Expecting files written inside a `-v` volume mount to be included in `podman commit` (volumes bypass the container's upper layer and are never committed!).
