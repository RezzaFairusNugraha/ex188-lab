#!/usr/bin/env python3
"""Acme Cloud Status & Notes Service (webapp-flask).
Vendor-supplied application for EX188 practice. DO NOT MODIFY.
Includes Flask primary runtime with automatic stdlib wsgiref fallback for air-gapped minimal images.
"""
import json
import os
import signal
import socket
import sys
import time
from pathlib import Path
from urllib.parse import parse_qs


def load_kv_config(path_str: str) -> dict:
    cfg = {
        "SITE_TITLE": "Acme Default Portal",
        "SUPPORT_TEAM": "unassigned@localhost",
        "MAINTENANCE_MODE": "false",
    }
    p = Path(path_str)
    if p.is_file():
        for raw in p.read_text(encoding="utf-8").splitlines():
            line = raw.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            k, v = line.split("=", 1)
            cfg[k.strip()] = v.strip().strip('"').strip("'")
    return cfg


def load_secret() -> tuple[bool, str]:
    secret_file = os.environ.get("APP_SECRET_FILE", "/run/secrets/webapp_secret")
    if secret_file and Path(secret_file).is_file():
        val = Path(secret_file).read_text(encoding="utf-8").strip()
        if val:
            return True, "file"
    env_val = os.environ.get("APP_SECRET", "").strip()
    if env_val:
        return True, "env"
    return False, "none"


def tcp_reachable(host: str, port: int, timeout: float = 1.5) -> bool:
    try:
        with socket.create_connection((host, port), timeout=timeout):
            return True
    except OSError:
        return False


def check_dependencies() -> tuple[bool, dict]:
    details = {}
    ok = True
    redis_host = os.environ.get("REDIS_HOST", "").strip()
    if redis_host:
        rport = int(os.environ.get("REDIS_PORT", "6379"))
        rok = tcp_reachable(redis_host, rport)
        details["redis"] = {"host": redis_host, "port": rport, "reachable": rok}
        if not rok:
            ok = False

    db_host = os.environ.get("DB_HOST", "").strip()
    if db_host:
        dport = int(os.environ.get("DB_PORT", "5432"))
        dok = tcp_reachable(db_host, dport)
        details["database"] = {"host": db_host, "port": dport, "reachable": dok}
        if not dok:
            ok = False

    if os.environ.get("CHECK_STORAGE", "0") == "1":
        data_dir = Path(os.environ.get("DATA_DIR", "/var/lib/webapp/data"))
        try:
            data_dir.mkdir(parents=True, exist_ok=True)
            probe = data_dir / ".rw-probe"
            probe.write_text("ok\n", encoding="utf-8")
            probe.unlink(missing_ok=True)
            details["storage"] = "writable"
        except OSError as exc:
            details["storage"] = f"error: {exc}"
            ok = False
    return ok, details


def build_summary() -> dict:
    cfg_path = os.environ.get("CONFIG_PATH", "/etc/webapp/app.conf")
    cfg = load_kv_config(cfg_path)
    sec_ok, sec_src = load_secret()
    return {
        "service": "webapp-flask",
        "env": os.environ.get("APP_ENV", "unset"),
        "site_title": cfg.get("SITE_TITLE"),
        "support_team": cfg.get("SUPPORT_TEAM"),
        "maintenance_mode": cfg.get("MAINTENANCE_MODE"),
        "uid": os.getuid() if hasattr(os, "getuid") else -1,
        "gid": os.getgid() if hasattr(os, "getgid") else -1,
        "hostname": socket.gethostname(),
        "secret_loaded": sec_ok,
        "secret_source": sec_src,
    }


def validate_startup() -> None:
    strict = os.environ.get("REQUIRE_STRICT_ENV", "0") == "1"
    app_env = os.environ.get("APP_ENV", "").strip()
    if strict and not app_env:
        sys.stderr.write("FATAL: APP_ENV is required when REQUIRE_STRICT_ENV=1\n")
        sys.exit(1)
    sec_ok, _ = load_secret()
    if os.environ.get("REQUIRE_SECRET", "0") == "1" and not sec_ok:
        sys.stderr.write("FATAL: Secret required via APP_SECRET_FILE or APP_SECRET\n")
        sys.exit(1)


def run_server() -> None:
    validate_startup()
    bind_addr = os.environ.get("APP_BIND", "0.0.0.0")
    port = int(os.environ.get("APP_PORT", "8080"))

    def handle_sigterm(_signum, _frame):
        sys.stdout.write("INFO: Received SIGTERM, shutting down cleanly.\n")
        sys.stdout.flush()
        sys.exit(0)

    signal.signal(signal.SIGTERM, handle_sigterm)

    try:
        from flask import Flask, jsonify, request

        app = Flask(__name__)

        @app.get("/")
        def index():
            return jsonify(build_summary()), 200

        @app.get("/healthz")
        def healthz():
            ok, deps = check_dependencies()
            code = 200 if ok else 503
            return jsonify({"status": "ok" if ok else "degraded", "dependencies": deps}), code

        @app.get("/config")
        def config_view():
            cfg_path = os.environ.get("CONFIG_PATH", "/etc/webapp/app.conf")
            return jsonify({"config_path": cfg_path, "values": load_kv_config(cfg_path)}), 200

        @app.route("/entries", methods=["GET", "POST"])
        def entries():
            data_dir = Path(os.environ.get("DATA_DIR", "/var/lib/webapp/data"))
            log_file = data_dir / "entries.log"
            if request.method == "POST":
                msg = request.args.get("msg") or request.get_data(as_text=True).strip() or "ping"
                try:
                    data_dir.mkdir(parents=True, exist_ok=True)
                    with log_file.open("a", encoding="utf-8") as fh:
                        fh.write(f"{int(time.time())} {msg}\n")
                except OSError as exc:
                    return jsonify({"error": str(exc)}), 500
                return jsonify({"written": msg}), 201
            lines = []
            if log_file.is_file():
                lines = log_file.read_text(encoding="utf-8").splitlines()
            return jsonify({"count": len(lines), "entries": lines}), 200

        sys.stdout.write(f"INFO: Starting webapp-flask (Flask) on {bind_addr}:{port}\n")
        sys.stdout.flush()
        app.run(host=bind_addr, port=port, debug=False)

    except ImportError:
        from wsgiref.simple_server import make_server

        def wsgi_app(environ, start_response):
            path = environ.get("PATH_INFO", "/")
            method = environ.get("REQUEST_METHOD", "GET")
            qs = parse_qs(environ.get("QUERY_STRING", ""))
            status = "200 OK"
            payload = {}

            if path == "/":
                payload = build_summary()
            elif path == "/healthz":
                ok, deps = check_dependencies()
                status = "200 OK" if ok else "503 Service Unavailable"
                payload = {"status": "ok" if ok else "degraded", "dependencies": deps}
            elif path == "/config":
                cfg_path = os.environ.get("CONFIG_PATH", "/etc/webapp/app.conf")
                payload = {"config_path": cfg_path, "values": load_kv_config(cfg_path)}
            elif path == "/entries":
                data_dir = Path(os.environ.get("DATA_DIR", "/var/lib/webapp/data"))
                log_file = data_dir / "entries.log"
                if method == "POST":
                    length = int(environ.get("CONTENT_LENGTH") or 0)
                    body = environ["wsgi.input"].read(length).decode("utf-8").strip() if length > 0 else ""
                    msg = (qs.get("msg", [""])[0] or body or "ping").strip()
                    try:
                        data_dir.mkdir(parents=True, exist_ok=True)
                        with log_file.open("a", encoding="utf-8") as fh:
                            fh.write(f"{int(time.time())} {msg}\n")
                        status = "201 Created"
                        payload = {"written": msg}
                    except OSError as exc:
                        status = "500 Internal Server Error"
                        payload = {"error": str(exc)}
                else:
                    lines = log_file.read_text(encoding="utf-8").splitlines() if log_file.is_file() else []
                    payload = {"count": len(lines), "entries": lines}
            else:
                status = "404 Not Found"
                payload = {"error": "not found"}

            raw = (json.dumps(payload) + "\n").encode("utf-8")
            start_response(status, [("Content-Type", "application/json"), ("Content-Length", str(len(raw)))])
            return [raw]

        sys.stdout.write(f"INFO: Starting webapp-flask (WSGI stdlib) on {bind_addr}:{port}\n")
        sys.stdout.flush()
        with make_server(bind_addr, port, wsgi_app) as httpd:
            httpd.serve_forever()


if __name__ == "__main__":
    run_server()
