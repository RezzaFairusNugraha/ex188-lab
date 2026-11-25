#!/usr/bin/env python3
"""PulseVote Frontend UI (vote-ui) — DO NOT MODIFY."""
import json
import os
import urllib.error
import urllib.request
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path

UI_PORT = int(os.environ.get("UI_PORT", "8080"))
API_BASE_URL = os.environ.get("API_BASE_URL", "http://vote-api:4000").rstrip("/")
VOTING_CONF = Path(os.environ.get("VOTING_CONF", "/etc/voting/voting.conf"))


def read_conf() -> dict:
    data = {"POLL_TITLE": "Default Poll", "OPTION_A": "Option A", "OPTION_B": "Option B"}
    if VOTING_CONF.is_file():
        for line in VOTING_CONF.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                k, v = line.split("=", 1)
                data[k.strip()] = v.strip()
    return data


class VoteUIHandler(BaseHTTPRequestHandler):
    def _send(self, code: int, payload: dict) -> None:
        raw = (json.dumps(payload) + "\n").encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(raw)))
        self.end_headers()
        self.wfile.write(raw)

    def do_GET(self):
        if self.path == "/healthz":
            try:
                with urllib.request.urlopen(f"{API_BASE_URL}/healthz", timeout=2) as resp:
                    api_data = json.loads(resp.read().decode("utf-8"))
                    self._send(200, {"status": "ok", "ui": "ready", "api": api_data})
            except Exception as exc:
                self._send(503, {"status": "degraded", "error": str(exc)})
            return

        if self.path in ("/", "/status"):
            cfg = read_conf()
            tally = {}
            try:
                with urllib.request.urlopen(f"{API_BASE_URL}/tally", timeout=2) as resp:
                    tally = json.loads(resp.read().decode("utf-8"))
            except Exception as exc:
                tally = {"error": str(exc)}
            self._send(200, {"service": "vote-ui", "config": cfg, "backend": tally})
            return

        self._send(404, {"error": "not found"})

    def do_POST(self):
        if self.path.startswith("/vote"):
            length = int(self.headers.get("Content-Length", "0"))
            body = self.rfile.read(length) if length > 0 else b'{"choice":"Podman Quadlet"}'
            req = urllib.request.Request(
                f"{API_BASE_URL}/vote",
                data=body,
                headers={"Content-Type": "application/json"},
                method="POST",
            )
            try:
                with urllib.request.urlopen(req, timeout=2) as resp:
                    self._send(resp.status, json.loads(resp.read().decode("utf-8")))
            except Exception as exc:
                self._send(502, {"error": str(exc)})
            return
        self._send(404, {"error": "not found"})


if __name__ == "__main__":
    HTTPServer(("0.0.0.0", UI_PORT), VoteUIHandler).serve_forever()
