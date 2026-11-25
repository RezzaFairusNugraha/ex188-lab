# Task 00-11: Persistent SELinux File Contexts with semanage fcontext and restorecon

## Scenario
Host directory `/srv/ex188-webroot` was created outside standard container paths and currently carries `var_t` (or `default_t`), which blocks confined containers when `:z`/`:Z` is not supplied by orchestration policy.

## Requirements
1. Ensure `/srv/ex188-webroot/assets/banner.txt` exists containing `SELinux Ready`.
2. Register a **persistent** SELinux file-context rule for `/srv/ex188-webroot(/.*)?` mapping its SELinux type to `container_file_t`.
3. Apply the policy to `/srv/ex188-webroot` and all nested files using `restorecon` (do **not** rely on temporary `chcon` alone, as `restorecon` must preserve `container_file_t`).
