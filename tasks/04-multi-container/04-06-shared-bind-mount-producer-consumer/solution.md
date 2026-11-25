## Solution
```bash
mkdir -p /home/student/workspace/04-06/spool/{inbox,outbox}

podman run -d --name job-consumer \
  --userns=keep-id:uid=1001,gid=1001 \
  -v /home/student/workspace/04-06/spool/inbox:/var/spool/worker/inbox:z \
  -v /home/student/workspace/04-06/spool/outbox:/var/spool/worker/outbox:z \
  localhost/worker-0406:1.0

podman run -d --name job-producer \
  -v /home/student/workspace/04-06/spool/inbox:/inbox:z \
  registry.access.redhat.com/ubi10/ubi-minimal:latest \
  sh -c 'echo "order-77" > /inbox/batch1.job && sleep 3600'
```

## Explanation
Notice why `job-producer` (running as default container root = host `student`) and `job-consumer` (`--userns=keep-id:uid=1001,gid=1001` = also host `student`!) agree on both **UID ownership** (`student`) AND **SELinux context** (`container_file_t:s0`)!

## Common Mistakes
- Passing `:Z` on `job-producer`, which steals the MCS label away from `job-consumer` and causes `job-consumer` to crash with `PermissionError`!
