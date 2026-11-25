## Solution
```bash
ss -tulpn | grep python3
# Probe each candidate port:
curl -s http://127.0.0.1:19620/status
printf '19620\n' > /home/student/workspace/00-08/probe-port.txt
curl -sS http://127.0.0.1:19620/status -o /home/student/workspace/00-08/status.json
```

## Explanation
`ss -tulpn` (`-t` TCP, `-u` UDP, `-l` listening, `-p` process, `-n` numeric ports) replaces legacy `netstat` on RHEL 10 and immediately reveals port conflicts or loopback-only (`127.0.0.1`) bindings.

## Common Mistakes
- Running `ss -tulp` without `-n`, causing service names to appear instead of numeric port numbers.
- Requesting `/` instead of `/status` and misidentifying the listener due to a `404` response.
