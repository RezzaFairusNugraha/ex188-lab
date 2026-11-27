# Task 05-20: Diagnosing Exit Code 137 (OOMKilled) via podman inspect and Tuning Memory

## Objective
Batch analytics container `batch-mem-0520` (`localhost/ts-mem-0520:1.0`, which allocates a 40 MiB Python buffer to process records and then stays alive serving results) keeps dying immediately with exit code **`137`** (`128 + 9 = SIGKILL`)!

## Specification
1. Inspect `batch-mem-0520` (`State.OOMKilled`, `State.ExitCode`, `HostConfig.Memory`) and write `OOMKILLED=<true|false>` and `OLD_MEMORY_BYTES=<bytes>` to `/home/student/workspace/05-20/oom-report.env`.
2. Without modifying the image `localhost/ts-mem-0520:1.0`, recreate `batch-mem-0520` with an adequate hard memory limit of **`128m`** (`--memory 128m --memory-swap 128m`) so the 40 MiB allocation succeeds and `batch-mem-0520` stays `running` (`BATCH_READY` in `podman logs`)!
