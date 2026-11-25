## Solution
```bash
grep -E 'ERROR|CRITICAL' /var/tmp/ex188-00-02/gateway.log \
  | grep -v '/healthz' \
  | tee /home/student/workspace/00-02/errors-all.log \
  | tail -n 3 > /home/student/workspace/00-02/errors-tail.log
```

## Explanation
`tee` writes standard input to `errors-all.log` while simultaneously passing the exact same stream forward to `tail -n 3`, avoiding reading or filtering the source log twice.

## Common Mistakes
- Using basic `grep 'ERROR|CRITICAL'` without `-E`, which treats `|` literally and outputs zero lines.
- Forgetting `grep -v '/healthz'`, leaving health probe noise in both output files.
