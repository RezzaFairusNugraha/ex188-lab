# Task 03-10: Filtering and Formatting Container Lifecycle Events with podman events

## Scenario
`podman events` audits container, image, volume, and pod lifecycle transitions (`create`, `init`, `start`, `die`, `remove`, `health_status`). Note that without `--stream=false` (or `--until`), `podman events` blocks forever waiting for live events!

## Requirements
1. Trigger a full lifecycle on container `event-probe` (`registry.access.redhat.com/ubi10/ubi-minimal:latest`): run it with `echo probe-done` so it starts and exits (`die`), leaving `event-probe` present or removed afterward.
2. Query historical events from the last 15 minutes (`--since 15m --stream=false`) filtered strictly to:
   - `type=container`
   - `container=event-probe`
   - events `start` and `die`
3. Format each output line as `{{.Status}} {{.Name}}` and save to `/home/student/workspace/03-10/events.log`.
