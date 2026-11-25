# Task 00-07: Diagnosing User Unit Failures with journalctl --user

## Scenario
A user systemd unit named `ex188-spoolcheck.service` failed during startup. You must inspect the systemd journal to determine why it exited and bring it into an active state without editing the script itself.

## Requirements
1. Query `journalctl --user` for `ex188-spoolcheck.service` and write the exact `DIAG_TOKEN=...` value emitted in its error log (only the token value after `=`) into `/home/student/workspace/00-07/diag-token.txt`.
2. Fix the missing filesystem prerequisite reported in the journal entry (do **not** modify `/home/student/workspace/00-07/spoolcheck.sh`).
3. Restart `ex188-spoolcheck.service` and verify its status is `active (running)`.
