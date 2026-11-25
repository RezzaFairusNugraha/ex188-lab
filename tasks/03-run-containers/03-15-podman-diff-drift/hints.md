## Level 1 — Nudge
Save `podman diff` **before** deleting `/tmp/unauthorized-dropper.sh` so `full-diff.txt` and `added-paths.txt` capture the initial drift!

## Level 2 — Approach
1. `podman diff drift-watch > ~/workspace/03-15/full-diff.txt`
2. Filter `^A ` with `awk '$1=="A" {print $2}' | sort` into `added-paths.txt`.
3. Run `podman exec drift-watch rm -f /tmp/unauthorized-dropper.sh`.

## Level 3 — Key Commands
```bash
podman diff drift-watch > ~/workspace/03-15/full-diff.txt
awk '$1=="A" {print $2}' ~/workspace/03-15/full-diff.txt | sort > ~/workspace/03-15/added-paths.txt
podman exec drift-watch rm -f /tmp/unauthorized-dropper.sh
```
