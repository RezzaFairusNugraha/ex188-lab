# Task 02-11: Semantic Multi-Tagging (2.3.1, 2.3, 2, latest) and Multi-Namespace Push

## Objective
A single `podman tag` command can apply **multiple** target tags to a source image in one invocation! You must publish `localhost/portal-build:ci` under semantic version tags into `registry.lab.local:5000/web/portal` and also push a backup tag into `registry.lab.local:5000/archive/portal:2.3.1`.

## Specification
1. Tag the pre-existing local image `localhost/portal-build:ci` with all four tags under `registry.lab.local:5000/web/portal`: `:2.3.1`, `:2.3`, `:2`, and `:latest`, plus `registry.lab.local:5000/archive/portal:2.3.1`.
2. Push all five tags to `registry.lab.local:5000` (`--tls-verify=false`).
