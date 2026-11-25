## Level 1 — Nudge
Combine extended regular expression matching (`grep -E`), inverted matching (`grep -v`), `tee`, and `tail -n` in a single pipeline.

## Level 2 — Approach
Match `ERROR|CRITICAL` first, pipe to `grep -v '/healthz'` to drop health probes, split the stream into `errors-all.log` with `tee`, and pipe the remainder into `tail -n 3` redirected to `errors-tail.log`.

## Level 3 — Key Commands
```bash
grep -E 'ERROR|CRITICAL' /var/tmp/ex188-00-02/gateway.log \
  | grep -v '/healthz' \
  | tee ~/workspace/00-02/errors-all.log \
  | tail -n 3 > ~/workspace/00-02/errors-tail.log
```
