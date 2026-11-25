# Task 05-17: Reclaiming Bloated Container Storage Without Disrupting Active Stateful Services

## Scenario
Container storage under `~/.local/share/containers/storage` accumulated >150 MiB of dead artifacts across stopped crash-dump containers, orphaned anonymous volumes, and unused bloated images — while `prod-keeper` (and its named volume `prod-keeper-vol`) is actively serving production data!

## Requirements
1. Inspect storage consumption with `podman system df -v`.
2. Reclaim at least **120 MiB** by removing stopped containers (`junk-crash-*`), unused volumes (`orphan-vol-*`), and unused bloated image `localhost/bloated-junk:old`.
3. Keep `prod-keeper` running and `prod-keeper-vol` (`keep.txt`) completely intact!
