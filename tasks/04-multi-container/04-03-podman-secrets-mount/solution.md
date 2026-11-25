## Solution
```bash
podman secret create nw_token /home/student/workspace/04-03/token.src
podman run -d --name sec-mount-api -p 3403:3000 \
  -e AUTH_REQUIRED=true \
  --secret nw_token,type=mount,target=/run/secrets/api_token,uid=1001,mode=0400 \
  localhost/api-0403:1.0
```

## Explanation
Notice `uid=1001,mode=0400` on `--secret`! Without `uid=1001`, a `0400` secret file defaults to `uid=0` (`root`), preventing non-root `USER 1001` from reading `/run/secrets/api_token`!

## Common Mistakes
- Setting `mode=0400` without `uid=1001` on a non-root container (`EACCES: permission denied, open '/run/secrets/api_token'`).
