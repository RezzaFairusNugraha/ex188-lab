# Task 00-08: Socket Discovery with ss -tulpn and HTTP Probing with curl

## Scenario
Two background Python HTTP listeners were started on high ports in your user session. One is a decoy service; the other serves a telemetry endpoint at `/status` returning `"service": "telemetry-probe"`.

## Requirements
1. Use `ss -tulpn` to discover the listening TCP ports owned by `python3`, and probe `/status` on each using `curl`.
2. Write **only the numeric TCP port** of the `telemetry-probe` listener into `/home/student/workspace/00-08/probe-port.txt`.
3. Save the raw JSON body returned by `GET /status` from `telemetry-probe` to `/home/student/workspace/00-08/status.json`.
