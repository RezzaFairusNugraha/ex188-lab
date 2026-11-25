## Solution
```bash
sudo groupadd -g 2450 containerops
sudo useradd -u 2401 -G containerops -s /sbin/nologin svcrunner
printf 'student ALL=(svcrunner) NOPASSWD: /usr/bin/id\n' | sudo tee /etc/sudoers.d/ex188-svcrunner >/dev/null
sudo chmod 0440 /etc/sudoers.d/ex188-svcrunner
sudo visudo -cf /etc/sudoers.d/ex188-svcrunner
```

## Explanation
`-G` appends supplementary groups while `-s /sbin/nologin` prevents interactive SSH logins for daemon accounts. Sudoers drop-ins should always be mode `0440` and syntax-checked with `visudo -cf`.

## Common Mistakes
- Passing `-g containerops` instead of `-G containerops` when a separate primary group was expected.
- Leaving `/etc/sudoers.d/ex188-svcrunner` world-writable or skipping `visudo -cf`.
