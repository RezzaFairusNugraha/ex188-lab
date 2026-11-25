## Solution
```bash
printf 'SELinux Ready\n' | sudo tee /srv/ex188-webroot/assets/banner.txt >/dev/null
sudo semanage fcontext -a -t container_file_t '/srv/ex188-webroot(/.*)?'
sudo restorecon -Rv /srv/ex188-webroot
```

## Explanation
Podman's `:Z` and `:z` mount options automatically apply `container_file_t` (with private MCS categories for `:Z` or shared `s0` for `:z`). When managing shared host paths manually or without `:z`/`:Z`, `semanage fcontext` + `restorecon` ensures relabels survive filesystem relabeling across reboots.

## Common Mistakes
- Using `chcon -Rt container_file_t` alone — grading or a full filesystem relabel runs `restorecon`, wiping unpersisted `chcon` labels.
- Forgetting single quotes around `'/srv/ex188-webroot(/.*)?'` in Bash.
