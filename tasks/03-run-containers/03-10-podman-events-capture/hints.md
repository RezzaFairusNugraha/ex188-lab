## Level 1 — Nudge
Pass multiple `--filter` (`-f`) flags (`type=container`, `container=event-probe`, `event=start`, `event=die`) along with `--stream=false` and `--format '{{.Status}} {{.Name}}'`.

## Level 2 — Approach
1. Run `podman run --rm --name event-probe registry.access.redhat.com/ubi10/ubi-minimal:latest echo probe-done`.
2. Run `podman events --since 15m --stream=false -f type=container -f container=event-probe -f event=start -f event=die --format '{{.Status}} {{.Name}}' > ~/workspace/03-10/events.log`.

## Level 3 — Key Commands
```bash
podman run --rm --name event-probe registry.access.redhat.com/ubi10/ubi-minimal:latest echo probe-done
podman events --since 15m --stream=false \
  --filter type=container \
  --filter container=event-probe \
  --filter event=start \
  --filter event=die \
  --format '{{.Status}} {{.Name}}' > ~/workspace/03-10/events.log
```
