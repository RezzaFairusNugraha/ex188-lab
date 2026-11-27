# Task 02-18: Observable Forensics: Classifying Mystery Images Built via save/load, export/import, and commit

## Objective
Setup created three local mystery images (`localhost/mystery-alpha:1.0`, `localhost/mystery-beta:1.0`, `localhost/mystery-gamma:1.0`). One was produced via `Containerfile` + `podman save`/`load`, one via `podman export`/`import`, and one via interactive container modification + `podman commit`.

## Specification
Inspect all three images using `podman history` and `podman image inspect` (`RootFS.Layers`, `Config.Env`, `History`), then write `/home/student/workspace/02-18/classification.env` with these three exact keys mapped to the full image name (`localhost/mystery-alpha:1.0`, `localhost/mystery-beta:1.0`, or `localhost/mystery-gamma:1.0`):
```ini
SAVE_LOAD_IMAGE=<image>
EXPORT_IMPORT_IMAGE=<image>
COMMIT_IMAGE=<image>
```
