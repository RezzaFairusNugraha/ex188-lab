# Task 00-02: Streams, Pipes, tee, and Log Filtering Pipelines

## Objective
An application gateway wrote mixed traffic and diagnostic lines to `/var/tmp/ex188-00-02/gateway.log`. You must isolate real error events while excluding noisy `/healthz` probes.

## Specification
1. Read `/var/tmp/ex188-00-02/gateway.log` and select every line containing either `ERROR` or `CRITICAL`, **excluding** any line that contains `/healthz`.
2. Write the complete filtered output to `/home/student/workspace/00-02/errors-all.log` (preserving original line order).
3. Write **only the last 3 lines** of that filtered output to `/home/student/workspace/00-02/errors-tail.log`.
