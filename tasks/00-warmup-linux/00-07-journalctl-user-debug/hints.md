## Level 1 — Nudge
Inspect recent logs for a specific user unit with `journalctl --user -u <unit> -xe`.

## Level 2 — Approach
Run `journalctl --user -u ex188-spoolcheck.service --no-pager`, note both the missing directory path and the `DIAG_TOKEN=...` string, save the token to `diag-token.txt`, create the missing directory, and `systemctl --user restart ex188-spoolcheck.service`.

## Level 3 — Key Commands
```bash
journalctl --user -u ex188-spoolcheck.service --no-pager
echo 'ERR_SPOOL_409' > ~/workspace/00-07/diag-token.txt
mkdir -p ~/workspace/00-07/incoming-jobs
systemctl --user restart ex188-spoolcheck.service
```
