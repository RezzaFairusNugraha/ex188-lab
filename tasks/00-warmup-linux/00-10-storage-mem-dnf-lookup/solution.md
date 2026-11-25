## Solution
```bash
cat > /home/student/workspace/00-10/host-audit.env <<EOF
ROOT_FSTYPE=$(df -PT / | awk 'NR==2 {print $2}')
TOTAL_MEM_MIB=$(free -m | awk '/^Mem:/ {print $2}')
SEMANAGE_RPM=policycoreutils-python-utils
EOF
```

## Explanation
`dnf provides '*/binary'` (and `rpm -qf` when already installed on the host) lets you quickly identify exact package names (`iproute`, `procps-ng`, `bind-utils`, `policycoreutils-python-utils`) needed inside UBI10 `Containerfile` `RUN dnf install -y ...` instructions.

## Common Mistakes
- Including version-release-arch (`policycoreutils-python-utils-3.x.el10.noarch`) instead of the base package name.
- Using `free -h` (human-readable GiB with units) instead of integer MiB from `free -m`.
