# Task 02-06: Enforcing Blocked Registries and Search Order in registries.conf

## Scenario
Corporate security policy requires rootless user `student` to:
1. Search `secure-reg.lab.local:5443` **first** and `registry.access.redhat.com` **second** for unqualified image names.
2. Completely **block** all image pulls from `untrusted-public.example.io` (and all sub-namespaces under it).
3. Pull short name `approved/mini-tool:1.0` (which setup published into `secure-reg.lab.local:5443/approved/mini-tool:1.0`) without typing the registry hostname!

## Requirements
1. Install the CA `/opt/ex188-lab/certs/ca.crt` for `secure-reg.lab.local:5443` if not already present.
2. Author `/home/student/.config/containers/registries.conf` (with `short-name-mode = "permissive"` so non-interactive short-name verification works) defining:
   - `unqualified-search-registries = ["secure-reg.lab.local:5443", "registry.access.redhat.com"]`
   - A `[[registry]]` rule blocking `prefix = "untrusted-public.example.io"` (`blocked = true`).
3. Pull `approved/mini-tool:1.0` by short name and re-tag it as `localhost/mini-tool:verified`.
