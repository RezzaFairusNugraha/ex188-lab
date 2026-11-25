## Level 1 — Nudge
Check `df -PT /` for filesystem type, `free -m` for total MiB, and `rpm -qf /usr/sbin/semanage` or `dnf provides /usr/sbin/semanage` for the package name.

## Level 2 — Approach
Extract column 2 of `df -PT /`, column 2 of `Mem:` in `free -m`, and `rpm -qf --qf '%{NAME}\n' /usr/sbin/semanage` (or `dnf provides`), then write the three unquoted `KEY=VALUE` entries into `host-audit.env`.

## Level 3 — Key Commands
```bash
cat > ~/workspace/00-10/host-audit.env <<EOF
ROOT_FSTYPE=$(df -PT / | awk 'NR==2 {print $2}')
TOTAL_MEM_MIB=$(free -m | awk '/^Mem:/ {print $2}')
SEMANAGE_RPM=$(rpm -qf --qf '%{NAME}' /usr/sbin/semanage)
EOF
```
