#!/usr/bin/env python3
"""Healthcheck probe for worker-py — DO NOT MODIFY."""
import os
import sys
import time
from pathlib import Path

hb = Path(os.environ.get("HEARTBEAT_FILE", "/tmp/worker.heartbeat"))
if not hb.is_file():
    sys.stderr.write("UNHEALTHY: heartbeat file missing\n")
    sys.exit(1)

age = time.time() - float(hb.read_text(encoding="utf-8").strip() or "0")
if age > 15:
    sys.stderr.write(f"UNHEALTHY: stale heartbeat ({age:.1f}s)\n")
    sys.exit(1)

print("HEALTHY")
sys.exit(0)
