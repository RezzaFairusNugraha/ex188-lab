## Solution
```bash
sudo systemctl enable --now firewalld
sudo firewall-cmd --permanent --add-port=8448/tcp
sudo firewall-cmd --permanent --add-port=5514/udp
sudo firewall-cmd --permanent --remove-port=9999/tcp
sudo firewall-cmd --reload
```

## Explanation
On an exam where the grading harness reboots the VM before running final checks, adding ports without `--permanent` works until reboot and then fails every network check; adding `--permanent` without `--reload` fails immediate runtime checks!

## Common Mistakes
- Running `firewall-cmd --add-port=8448/tcp` without `--permanent` (lost on reboot).
- Running `firewall-cmd --permanent --add-port=8448/tcp` without `firewall-cmd --reload` (not active in current boot).
