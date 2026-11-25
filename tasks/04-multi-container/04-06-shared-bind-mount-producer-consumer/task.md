# Task 04-06: Shared Host Bind Mount (:z) Between Producer and Consumer Containers

## Scenario
Two containers (`job-producer` and `job-consumer`) must share the **same** host spool directory `/home/student/workspace/04-06/spool/{inbox,outbox}` on SELinux-enforcing RHEL 10. Remember: `:Z` locks MCS categories to a single container and locks the first container out! You **must** use lowercase shared `:z`!

## Requirements
1. Create `/home/student/workspace/04-06/spool/inbox` and `/home/student/workspace/04-06/spool/outbox`.
2. Start `job-consumer` from pre-built `localhost/worker-0406:1.0` (`USER 1001`) with `--userns=keep-id:uid=1001,gid=1001`, mounting both `inbox` and `outbox` with **shared** `:z`.
3. Start `job-producer` (`registry.access.redhat.com/ubi10/ubi-minimal:latest`) mounting `inbox` with **shared** `:z` running:
   `sh -c 'echo "order-77" > /inbox/batch1.job && sleep 3600'`
4. Verify `job-consumer` processes `batch1.job` into `/home/student/workspace/04-06/spool/outbox/batch1.done` while **both** containers remain running and able to access `/inbox`!
