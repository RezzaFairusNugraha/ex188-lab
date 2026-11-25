## Solution
```bash
podman pull --tls-verify=false registry.lab.local:5000/sec/audit-runner:v1
DIG="$(podman image inspect --format '{{.Digest}}' registry.lab.local:5000/sec/audit-runner:v1)"
REF="registry.lab.local:5000/sec/audit-runner@${DIG}"
printf '%s\n' "${REF}" > /home/student/workspace/02-10/pinned-ref.txt
podman run -d --tls-verify=false --name digest-runner "${REF}" sleep 3600
```

## Explanation
Notice that `repo:v1@sha256:...` is discouraged; standard digest pull syntax replaces `:tag` with `@sha256:...` (`registry/namespace/repo@sha256:...`).

## Common Mistakes
- Keeping `:v1` before `@sha256:...` in `pinned-ref.txt` instead of `repo@sha256:...`.
