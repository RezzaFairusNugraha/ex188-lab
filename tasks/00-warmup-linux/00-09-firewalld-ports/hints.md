## Level 1 — Nudge
Changes made with `firewall-cmd --permanent` do not affect active traffic until `firewall-cmd --reload` is executed.

## Level 2 — Approach
Use `sudo firewall-cmd --permanent --add-port=...` for both required ports, `--permanent --remove-port=9999/tcp` for the stale rule, and finish with `sudo firewall-cmd --reload` and `sudo firewall-cmd --list-ports`.

## Level 3 — Key Commands
```bash
sudo firewall-cmd --permanent --add-port=8448/tcp
sudo firewall-cmd --permanent --add-port=5514/udp
sudo firewall-cmd --permanent --remove-port=9999/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --list-ports
```
