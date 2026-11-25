# Task 05-11: Resolving Image Pull Failure: Blocked Registry Rule + Invalid Stored Credentials

## Scenario
`podman pull auth-reg.lab.local:5444/sec/scanner:2.0` fails for user `student`. Investigate user/system `registries.conf` files and stored auth credentials (`~/.config/containers/auth.json` vs `XDG_RUNTIME_DIR`), fix the configuration using valid account `student` / `redhat123`, and start container `sec-scanner` (`sleep 3600`).

## Requirements
1. Fix the broken `blocked = true` rule in `~/.config/containers/registries.conf` affecting `auth-reg.lab.local:5444`.
2. Replace the invalid credentials in `/home/student/.config/containers/auth.json` using `podman login` (`student` / `redhat123`).
3. Pull `auth-reg.lab.local:5444/sec/scanner:2.0` (`--tls-verify=true`) and start detached container `sec-scanner` running `sleep 3600`.
