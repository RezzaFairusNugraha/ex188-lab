## Solution
```bash
for img in localhost/mystery-{alpha,beta,gamma}:1.0; do
  printf '=== %s ===\n' "${img}"
  podman history "${img}"
done

cat > /home/student/workspace/02-18/classification.env <<'EOF'
SAVE_LOAD_IMAGE=localhost/mystery-gamma:1.0
EXPORT_IMPORT_IMAGE=localhost/mystery-alpha:1.0
COMMIT_IMAGE=localhost/mystery-beta:1.0
EOF
```

## Explanation
| Method | Layers (`RootFS.Layers`) | Metadata (`ENV`/`USER`/`CMD`) | `podman history` |
| :--- | :--- | :--- | :--- |
| `save` / `load` | All original layers preserved | 100% preserved | Full `Containerfile` build steps |
| `export` / `import` | Flattened to **1** layer | **Wiped** (unless `--change`) | Single `imported from tarball` entry |
| `commit` | Base layers + **1** upper diff layer | Inherited from container (+ `--change`) | Base history + single top commit entry |

## Common Mistakes
- Confusing `podman save` (image archive) with `podman export` (container filesystem dump).
