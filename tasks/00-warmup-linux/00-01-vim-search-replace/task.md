# Task 00-01: Vim Authoring and Batch Search-Replace Without a GUI

## Objective
You have been handed a draft manifest at `/home/student/workspace/00-01/service-draft.yaml` that still points to legacy registry paths and deprecated configuration keys.

## Specification
Edit `/home/student/workspace/00-01/service-draft.yaml` in place (using `vim` or standard CLI tools) so the final file satisfies all of the following conditions:

1. Replace every occurrence of `docker.io/legacycorp` with `registry.access.redhat.com/ubi10`.
2. Replace every occurrence of `containerPort: 80` with `containerPort: 8080` (or `TARGET_PORT` if `--seed` is active).
3. Delete every line containing the marker `DEPRECATED_SETTING`.
4. Ensure the top-level `spec:` block contains the exact line `  restartPolicy: Always` (indented by two spaces).
