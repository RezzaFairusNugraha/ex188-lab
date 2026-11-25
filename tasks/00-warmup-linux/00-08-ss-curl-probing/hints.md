## Level 1 — Nudge
Run `ss -tulpn` to list listening TCP sockets and owning processes, then query `/status` on each candidate port with `curl -s`.

## Level 2 — Approach
Filter `ss -tulpn | grep python3` to locate the two `127.0.0.1:<port>` listeners. Run `curl -s http://127.0.0.1:<port>/status` against both, identify which returns `"telemetry-probe"`, and write its port and JSON response to the two target files.

## Level 3 — Key Commands
```bash
ss -tulpn | grep python3
curl -s http://127.0.0.1:19620/status
echo '19620' > ~/workspace/00-08/probe-port.txt
curl -s http://127.0.0.1:19620/status -o ~/workspace/00-08/status.json
```
