## Solution
```bash
journalctl --user -u ex188-spoolcheck.service --no-pager
printf 'ERR_SPOOL_409\n' > /home/student/workspace/00-07/diag-token.txt
mkdir -p /home/student/workspace/00-07/incoming-jobs
systemctl --user restart ex188-spoolcheck.service
systemctl --user status ex188-spoolcheck.service
```

## Explanation
When Quadlet-generated `.container` units fail to launch on the exam, `journalctl --user -u <name>.service -xe` is the primary diagnostic tool because container creation errors occur before `podman logs` even has a container to inspect.

## Common Mistakes
- Omitting `--user` when calling `journalctl`, which searches the system journal rather than the user unit journal.
- Writing `DIAG_TOKEN=ERR_SPOOL_409` instead of just the token value `ERR_SPOOL_409`.
