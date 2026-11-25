## Solution
```bash
podman run --rm --name event-probe \
  registry.access.redhat.com/ubi10/ubi-minimal:latest echo probe-done

podman events --since 15m --stream=false \
  --filter type=container \
  --filter container=event-probe \
  --filter event=start \
  --filter event=die \
  --format '{{.Status}} {{.Name}}' \
  > /home/student/workspace/03-10/events.log
```

## Explanation
Multiple `--filter event=...` flags act as a logical OR across event types while ANDing with `type=container` and `container=event-probe`. Adding `--stream=false` exits cleanly once stored events have been printed!

## Common Mistakes
- Omitting `--stream=false`, causing `podman events` to hang indefinitely in your terminal!
