## Level 1 — Nudge
Use `groupadd -g`, `useradd` with explicit UID/shell/supplementary-group flags, and validate any file under `/etc/sudoers.d/` with `visudo -cf`.

## Level 2 — Approach
1. Create `containerops` with GID `2450`.
2. Create `svcrunner` specifying `-u`, `-G containerops`, and `-s /sbin/nologin`.
3. Write `student ALL=(svcrunner) NOPASSWD: /usr/bin/id` to `/etc/sudoers.d/ex188-svcrunner`, set `chmod 0440`, and verify with `visudo -cf`.

## Level 3 — Key Commands
```bash
sudo groupadd -g 2450 containerops
sudo useradd -u 2401 -G containerops -s /sbin/nologin svcrunner
echo 'student ALL=(svcrunner) NOPASSWD: /usr/bin/id' | sudo tee /etc/sudoers.d/ex188-svcrunner
sudo chmod 0440 /etc/sudoers.d/ex188-svcrunner
sudo visudo -cf /etc/sudoers.d/ex188-svcrunner
```
