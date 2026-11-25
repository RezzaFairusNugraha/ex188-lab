#!/usr/bin/env python3
"""Spool Queue Worker (worker-py) — DO NOT MODIFY."""
import argparse
import os
import signal
import sys
import time
from pathlib import Path

RUNNING = True


def _stop(_sig, _frame):
    global RUNNING
    sys.stdout.write("INFO: worker-py received stop signal, exiting cleanly.\n")
    sys.stdout.flush()
    RUNNING = False


def main() -> None:
    parser = argparse.ArgumentParser(description="EX188 Spool Queue Worker")
    parser.add_argument("--interval", type=float, default=float(os.environ.get("POLL_SECONDS", "2")))
    parser.add_argument("--prefix", type=str, default=os.environ.get("WORKER_PREFIX", "PROCESSED"))
    args = parser.parse_args()

    inbox = Path(os.environ.get("INBOX_DIR", "/var/spool/worker/inbox"))
    outbox = Path(os.environ.get("OUTBOX_DIR", "/var/spool/worker/outbox"))
    hb = Path(os.environ.get("HEARTBEAT_FILE", "/tmp/worker.heartbeat"))

    signal.signal(signal.SIGTERM, _stop)
    signal.signal(signal.SIGINT, _stop)

    inbox.mkdir(parents=True, exist_ok=True)
    outbox.mkdir(parents=True, exist_ok=True)
    sys.stdout.write(f"INFO: worker-py started (inbox={inbox}, outbox={outbox}, interval={args.interval}s)\n")
    sys.stdout.flush()

    while RUNNING:
        hb.write_text(f"{time.time():.0f}\n", encoding="utf-8")
        for job in sorted(inbox.glob("*.job")):
            content = job.read_text(encoding="utf-8").strip()
            dest = outbox / (job.stem + ".done")
            dest.write_text(f"{args.prefix}: {content.upper()}\n", encoding="utf-8")
            job.unlink(missing_ok=True)
            sys.stdout.write(f"INFO: processed {job.name} -> {dest.name}\n")
            sys.stdout.flush()
        time.sleep(args.interval)


if __name__ == "__main__":
    main()
