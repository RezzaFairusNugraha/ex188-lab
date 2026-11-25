## Solution
```bash
chmod 0755 /home/student/workspace/05-07/data
podman rm -f selinux-victim
podman run -d --name selinux-victim \
  -p 8507:8080 \
  --userns=keep-id:uid=1001,gid=1001 \
  -e APP_ENV=production \
  -e CHECK_STORAGE=1 \
  -v /home/student/workspace/05-07/data:/var/lib/webapp/data:Z \
  localhost/ts-web-0507:1.0
```

## Explanation
Whenever `Permission denied` persists even on a `0777` directory on RHEL 10, **SELinux Mandatory Access Control (MAC)** is the culprit (`ls -Z`). Never run `setenforce 0` on a Red Hat exam — automated grading verifies SELinux remains `Enforcing`!

## Common Mistakes
- Passing `--security-opt label=disable` instead of `:Z`, which strips SELinux confinement from the container process.
