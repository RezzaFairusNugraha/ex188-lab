## Level 1 — Nudge
Vim supports whole-file substitution, pattern-matched line deletion, and visible whitespace/line-number guides without leaving command mode.

## Level 2 — Approach
Open the YAML file in `vim`, enable `:set number expandtab shiftwidth=2`, run a global `:s` substitution for the registry path and port, run `:g/PATTERN/d` to strip deprecated lines, and add `restartPolicy: Always` aligned with `containers:`.

## Level 3 — Key Commands
Inside `vim /home/student/workspace/00-01/service-draft.yaml`:
```vim
:%s#docker.io/legacycorp#registry.access.redhat.com/ubi10#g
:%s/containerPort: 80/containerPort: 8080/g
:g/DEPRECATED_SETTING/d
```
Then insert `  restartPolicy: Always` directly beneath `spec:` and save with `:wq`.
