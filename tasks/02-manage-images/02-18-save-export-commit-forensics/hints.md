## Level 1 — Nudge
Compare `podman history <img >` and `podman image inspect --format '{{len .RootFS.Layers}} | {{.Config.Env}}' <img>` across all three mystery images!

## Level 2 — Approach
- The `export/import` image has **1 layer** total, `imported from tarball` in `podman history`, and stripped `ENV`/`USER`.
- The `commit` image keeps the base UBI layers plus 1 top layer whose `COMMENT` shows the commit message instead of `Containerfile` `RUN`/`ENV` steps.
- The `save/load` image retains every `Containerfile` `RUN`, `ENV`, and `USER` history entry intact.

## Level 3 — Key Commands
```bash
for img in localhost/mystery-{alpha,beta,gamma}:1.0; do
  echo "=== $img ==="
  podman history "$img"
  podman image inspect --format 'Layers={{len .RootFS.Layers}} User={{.Config.User}} Env={{.Config.Env}}' "$img"
done
```
