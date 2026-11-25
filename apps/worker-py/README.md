# Spool Queue Worker (`worker-py`)

> **IMPORTANT — VENDOR APPLICATION NOTICE**
> Do **not** edit `worker.py` or `healthcheck.py`. Configure paths, poll intervals, and volumes strictly via `Containerfile` instructions and runtime flags.

## 1. Overview
`worker-py` watches an input spool directory (`INBOX_DIR`), converts `.job` text files into upper-case `.done` results inside `OUTBOX_DIR`, writes a periodic heartbeat file for container `HEALTHCHECK` verification, and logs structured lines to `stdout`.

## 2. Runtime Variables & Arguments
- `INBOX_DIR` (default `/var/spool/worker/inbox`)
- `OUTBOX_DIR` (default `/var/spool/worker/outbox`)
- `HEARTBEAT_FILE` (default `/tmp/worker.heartbeat`)
- `POLL_SECONDS` (default `2`, can also be passed via CLI flag `--interval <sec>`)
- **Healthcheck Command**: `python3 /opt/worker/healthcheck.py` (verifies `HEARTBEAT_FILE` was updated within the last 15 seconds).
