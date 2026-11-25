#!/usr/bin/env bash
set -euo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/state.sh"

seed_init "00-08"
seed_port "00-08" DECOY_PORT 19110 19100 19499
seed_port "00-08" PROBE_PORT 19620 19500 19899

WORK="$(student_home)/workspace/00-08"
if [[ -f "${WORK}/pids.txt" ]]; then
    xargs -r kill < "${WORK}/pids.txt" 2>/dev/null || true
fi
rm -rf "${WORK}"
mkdir -p "${WORK}"

python3 - "${DECOY_PORT}" "decoy-metrics" >/dev/null 2>&1 <<'PY' &
import json, sys
from http.server import BaseHTTPRequestHandler, HTTPServer
port, name = int(sys.argv[1]), sys.argv[2]
class H(BaseHTTPRequestHandler):
    def log_message(self, *a): pass
    def do_GET(self):
        body = (json.dumps({"service": name, "ready": True}) + "\n").encode()
        self.send_response(200); self.send_header("Content-Type", "application/json"); self.end_headers(); self.wfile.write(body)
HTTPServer(("127.0.0.1", port), H).serve_forever()
PY
echo $! >> "${WORK}/pids.txt"

python3 - "${PROBE_PORT}" "telemetry-probe" >/dev/null 2>&1 <<'PY' &
import json, sys
from http.server import BaseHTTPRequestHandler, HTTPServer
port, name = int(sys.argv[1]), sys.argv[2]
class H(BaseHTTPRequestHandler):
    def log_message(self, *a): pass
    def do_GET(self):
        if self.path == "/status":
            body = (json.dumps({"service": name, "port": port, "state": "nominal"}) + "\n").encode()
            self.send_response(200)
        else:
            body = b'{"error":"use /status"}\n'
            self.send_response(404)
        self.send_header("Content-Type", "application/json"); self.end_headers(); self.wfile.write(body)
HTTPServer(("127.0.0.1", port), H).serve_forever()
PY
echo $! >> "${WORK}/pids.txt"
sleep 1
