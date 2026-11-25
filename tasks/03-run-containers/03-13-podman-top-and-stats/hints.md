## Level 1 — Nudge
Check `man podman-top` (`--list-descriptors`) and `man podman-stats` (`--no-stream`).

## Level 2 — Approach
Run `podman top metrics-target user huser pid hpid comm > ~/workspace/03-13/top-map.txt` and `podman stats --no-stream --format "{{.Name}} {{.MemUsage}}" metrics-target > ~/workspace/03-13/stats.txt`.

## Level 3 — Key Commands
```bash
podman top metrics-target user huser pid hpid comm > ~/workspace/03-13/top-map.txt
podman stats --no-stream --format "{{.Name}} {{.MemUsage}}" metrics-target > ~/workspace/03-13/stats.txt
```
